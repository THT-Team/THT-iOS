//
//  HeightVM.swift
//  MyPage
//
//  Created by Kanghos on 7/22/24.
//

import Foundation

import Core
import RxSwift
import RxCocoa
import DSKit
import MyPageInterface

public protocol BottomSheetViewModelType {
  var handler: BottomSheetHandler? { get set }
  var onDismiss: (() -> Void)? { get set }
}

final class HeightEditVM: ViewModelType, BottomSheetViewModelType {
  struct Input {
    let viewDidAppear: Driver<Void>
    let selectedItem: Driver<(row: Int, component: Int)>
    let btnTap: Signal<Void>
  }

  struct Output {
    let items: Driver<[[Int]]>
    let initialHeight: Driver<Int>
    let isBtnEnabled: Driver<Bool>
  }

  private var disposeBag = DisposeBag()
  private let initialValue: BottomSheetValueType
  private let useCase: MyPageUseCaseInterface
  public var handler: BottomSheetHandler?
  public var onDismiss: (() -> Void)?
  public let userStore: UserStore

  init(
    initialValue: BottomSheetValueType,
    useCase: MyPageUseCaseInterface,
    userStore: UserStore
  ) {
    self.initialValue = initialValue
    self.useCase = useCase
    self.userStore = userStore
  }

  func transform(input: Input) -> Output {
    let range = [Array(145...200)]
    let defaultValue: Int = range[0].index(after: 0)
    let items = Driver<[[Int]]>.just(range)
    let initialHeight = Driver.just(self.initialValue)
      .compactMap {
        if case let .text(value) = $0 {
          return Int(value) ?? defaultValue
        }
        return nil
      }
    let selectedHeight = input.selectedItem
      .withLatestFrom(items) { selectedItem, array in
        let (row, component) = selectedItem
        return array[component][row]
      }
    let isBtnEnabled = Driver.combineLatest(initialHeight, selectedHeight) { $0 != $1 }
    
    let initialHeightIndex = Driver.zip(initialHeight, input.viewDidAppear) { height, _ in height }
      .withLatestFrom(items) { height, array -> Int in
        array[0].firstIndex(where: { $0 == height }) ?? array[0].startIndex
      }
    
    input.btnTap
      .asDriver(onErrorDriveWith: .empty())
      .withLatestFrom(isBtnEnabled)
      .filter { $0 }
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(selectedHeight)
      .flatMapLatest { [unowned self] height in
        self.useCase.updateHeight(height)
          .map { _ in height }
          .asDriver { error in
            
            return .empty()
          }
      }
      .drive(with: self) { owner, height in
        owner.userStore.send(action: .height(height))
        owner.onDismiss?()
        owner.handler?(.text(text: "\(height)"))
      }
      .disposed(by: disposeBag)

    return Output(
      items: items,
      initialHeight: initialHeightIndex,
      isBtnEnabled: isBtnEnabled
    )
  }
}


