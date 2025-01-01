//
//  TFBaseEmojiEditVM.swift
//  MyPage
//
//  Created by kangho lee on 7/24/24.
//

import Foundation
import DSKit

import RxSwift
import RxCocoa

import Domain
import MyPageInterface

public protocol EmojiPropertyType {
  var emojiCode: String { get }
}

public protocol CVEmojiOutputType {
  associatedtype ModelType: Hashable, EmojiPropertyType
  typealias ItemVM = InputTagItemViewModel
  var items: Driver<[ItemVM]> { get }
  var isBtnEnabled: Driver<Bool> { get }
}

protocol FetchEmojiProtocol {
  func fetch(initial: [Int]) -> Driver<[Domain.InputTagItemViewModel]>
}

protocol EmojiSendable {
  func send(item: [EmojiType])
}

public protocol CVEmojiPickerVMType: ViewModelType where Input: CVInputType, Output: CVEmojiOutputType  { }

open class TFBaseEmojiEditVM: CVEmojiPickerVMType, FetchEmojiProtocol, EmojiSendable, BottomSheetViewModelType {
  public typealias ItemVMType = InputTagItemViewModel


  private var disposeBag = DisposeBag()
  
  private let initialValue: BottomSheetValueType
  let useCase: UserDomainUseCaseInterface
  let userStore: UserStore

  public var onDismiss: (() -> Void)?
  public var handler: BottomSheetHandler?

  public init(
    initialValue: BottomSheetValueType,
    useCase: UserDomainUseCaseInterface,
    userStore: UserStore
  ) {
    self.initialValue = initialValue
    self.useCase = useCase
    self.userStore = userStore
  }

  public struct Input: CVInputType {
    public let selectedItem: Driver<Int>
    public let btnTap: Signal<Void>
    public init(selectedItem: Driver<Int>, btnTap: Signal<Void>) {
      self.selectedItem = selectedItem
      self.btnTap = btnTap
    }
  }
  
  public struct Output: CVEmojiOutputType {
    public typealias ModelType = Domain.EmojiType
    
    public let items: Driver<[ItemVMType]>
    public let isBtnEnabled: Driver<Bool>
  }
  
  public func transform(input: Input) -> Output {
    let snapshot = BehaviorRelay<[ItemVMType]>(value: [])
    let queue = BehaviorRelay(value: Queue<ItemVMType>(maxSize: 3))
    let chips = snapshot.asDriver()
    let selectedItems = queue.asDriver()

    let initialValue = Driver.just(self.initialValue)
      .compactMap {
      if case let .text(value) = $0 {
        return value.components(separatedBy: ",").compactMap { Int($0) }
      }
      return nil
    }

    let emoji = initialValue
      .flatMapLatest(with: self) { owner, initial in
        owner.fetch(initial: initial)
      }

    emoji.map { $0.filter { $0.isSelected } }
      .withLatestFrom(selectedItems) { selected, queue in
        var queue = queue
        selected.forEach { queue.enqueue($0) }
        return queue
      }.drive(queue)
      .disposed(by: disposeBag)

    emoji
      .drive(snapshot)
      .disposed(by: disposeBag)
    
    input.selectedItem
      .withLatestFrom(chips) { index, array in
        array[index]
      }
      .withLatestFrom(selectedItems) { item, queue in
        var queue = queue
        queue.enqueue(item)
        return queue
      }.drive(queue)
      .disposed(by: disposeBag)
    
    selectedItems
      .withLatestFrom(chips) { queue, chips in
        var mutable = chips.map {
          var item = $0
          item.isSelected = false
          return item
        }
        queue.current().forEach { element in
          if let index = mutable.firstIndex(of: element) {
            mutable[index].isSelected = true
          }
        }
        return mutable
      }.drive(snapshot)
      .disposed(by: disposeBag)
    
    let initialSet = initialValue.map { $0 }
    let currentSet = selectedItems.map { $0.current().map(\.emojiType.idx) }

    let diffValidate = Driver.combineLatest(currentSet, initialSet) { Set($0) != Set($1) && $0.count == 3 }
      .startWith(false)
    
    let isNextBtnEnabled = diffValidate

    input.btnTap
      .asDriver(onErrorDriveWith: .empty())
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(isNextBtnEnabled)
      .filter { $0 }
      .withLatestFrom(chips.asDriver()) { _, chips in
        chips.filter { $0.isSelected }
          .map(\.emojiType)
      }
      .drive(with: self, onNext: { owner, chips in
        owner.send(item: chips)
        owner.onDismiss?()
      })
      .disposed(by: disposeBag)
    
    return Output(
      items: chips.asDriver(),
      isBtnEnabled: isNextBtnEnabled)
  }
  
  func fetch(initial: [Int]) -> Driver<[ItemVMType]> {
    fatalError()
  }

  func send(item: [EmojiType]) {
    fatalError()
  }
}
