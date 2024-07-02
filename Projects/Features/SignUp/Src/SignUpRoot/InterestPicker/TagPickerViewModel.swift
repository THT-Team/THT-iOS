//
//  InterestPickerViewModel.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import Foundation

import Core
import SignUpInterface

import RxSwift
import RxCocoa
import Domain
import DSKit

public protocol EmojiPickerProtocol {
  func fetchInitialEmojiIndex() -> Driver<[Int]>
  func nextPage()
  func saveEmoji(_ emoji: [EmojiType])
}

open class TFBaseEmojiVM: BaseTagPickerViewModel, ViewModelType, EmojiPickerProtocol {
  public typealias ItemVMType = InputTagItemViewModel

  public struct Input {
    var chipTap: Driver<IndexPath>
    var nextBtnTap: Driver<Void>
  }

  public struct Output {
    var chips: Driver<[InputTagItemViewModel]>
    var isNextBtnEnabled: Driver<Bool>
  }

  public func transform(input: Input) -> Output {
    let snapshot = BehaviorRelay<[ItemVMType]>(value: [])
    let queue = BehaviorRelay(value: Queue<ItemVMType>(maxSize: 3))
    let chips = snapshot.asDriver()
    let selectedItems = queue.asDriver()

    let emoji = fetchInitialEmojiIndex()
      .flatMapLatest(with: self) { owner, initial in
        owner.fetch(initial: initial)
      }

    emoji.drive(snapshot)
      .disposed(by: disposeBag)

    emoji.map { $0.filter { $0.isSelected }}
      .map { selected in
        var queue = Queue<ItemVMType>(maxSize: 3)
        selected.forEach { queue.enqueue($0) }
        return queue
      }.drive(queue)
      .disposed(by: disposeBag)

    input.chipTap.map(\.item)
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

//    .drive(chips)
//    .disposed(by: disposeBag)

//    input.chipTap.map { $0.item }
//      .withLatestFrom(chips.asDriver()) { index, chips in
//        var prev = chips.enumerated().filter { $0.element.isSelected }.map { $0.offset }
//
//        if prev.contains(index) {
//          prev.removeAll { $0 == index }
//        } else if prev.count < 3 {
//          prev.append(index)
//        }
//        var mutable = chips.map {
//          var model = $0
//          model.isSelected = false
//          return model
//        }
//
//        prev.forEach { index in
//          mutable[index].isSelected = true
//        }
//
//        return mutable
//      }.drive(chips)
//      .disposed(by: disposeBag)

    let isNextBtnEnabled = selectedItems
      .map { $0.current().count == 3 }

    input.nextBtnTap
      .withLatestFrom(isNextBtnEnabled)
      .filter { $0 }
      .withLatestFrom(selectedItems) { $1.current().map(\.emojiType) }
      .drive(with: self, onNext: { owner, chips in
        owner.saveEmoji(chips)
        owner.nextPage()
      })
      .disposed(by: disposeBag)

    return Output(
      chips: chips.asDriver(),
      isNextBtnEnabled: isNextBtnEnabled
    )
  }

  public func fetchInitialEmojiIndex() -> Driver<[Int]> {
    fatalError()
  }

  public func fetch(initial: [Int]) -> Driver<[ItemVMType]> {
    fatalError()
  }

  public func nextPage() {
    fatalError()
  }

  public func saveEmoji(_ emoji: [EmojiType]) {
    fatalError()
  }
}

final class InterestPickerVM: TFBaseEmojiVM {
  override func fetch(initial: [Int]) -> Driver<[TFBaseEmojiVM.ItemVMType]> {
    userDomainUseCase.fetchEmoji(initial: initial, type: .interest)
      .asDriver(onErrorJustReturn: [])
  }

  override func fetchInitialEmojiIndex() -> Driver<[Int]> {
    Driver.just(pendingUser.interestsList)
  }

  override func saveEmoji(_ emoji: [EmojiType]) {
    pendingUser.interestsList = emoji.map(\.idx)
    useCase.savePendingUser(pendingUser)
  }

  override func nextPage() {
    delegate?.invoke(.nextAtInterest, pendingUser)
  }
}

final class IdealTypePickerVM: TFBaseEmojiVM {
  override func fetch(initial: [Int]) -> Driver<[TFBaseEmojiVM.ItemVMType]> {
    userDomainUseCase.fetchEmoji(initial: initial, type: .idealType)
      .asDriver(onErrorJustReturn: [])
  }
  override func fetchInitialEmojiIndex() -> Driver<[Int]> {
    Driver.just(pendingUser.idealTypeList)
  }
  override func saveEmoji(_ emoji: [EmojiType]) {
    pendingUser.idealTypeList = emoji.map(\.idx)
    useCase.savePendingUser(pendingUser)
  }

  override func nextPage() {
    delegate?.invoke(.nextAtIdealType, pendingUser)
  }
}
