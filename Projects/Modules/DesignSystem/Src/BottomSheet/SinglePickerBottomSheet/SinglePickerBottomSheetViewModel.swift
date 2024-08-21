//
//  SinglePickerBottomSheetViewModel.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import Foundation

import RxSwift
import RxCocoa

import Core

public class SinglePickerBottomSheetViewModel: ViewModelType {
//  private let filterType: Item
  private let initialValue: BottomSheetValueType

  public weak var listener: BottomSheetListener?
  public weak var delegate: BottomSheetActionDelegate?

  private var disposeBag = DisposeBag()

  public init(initialValue: BottomSheetValueType) {
    self.initialValue = initialValue
  }

  public struct Input {
    let selectedItem: Driver<(row: Int, component: Int)>
    let initializeButtonTap: Driver<Void>
  }

  public struct Output {
    let items: Driver<[[Int]]>
    let initialHeight: Driver<Int>
    let isBtnEnabled: Driver<Bool>
  }

  public func transform(input: Input) -> Output {
    let range = [Array(145...200)]
    let defaultValue: Int = range[0].index(after: 0)
    let items = Driver<[[Int]]>.just(range)
    let initialHeight = Driver.just(self.initialValue)
      .compactMap {
        if case let .text(value) = $0 {
          return Int(value) ?? 145
        }
        return nil
      }

    let selectedValue = input.selectedItem
      .withLatestFrom(items) { picker, items in
          return items[picker.component][picker.row]
      }
    let initialHeightIndex = initialHeight
      .withLatestFrom(items) { height, array -> Int in
        array[0].firstIndex(where: { $0 == height }) ?? defaultValue
      }
    
    let isBtnEnabled = Driver.combineLatest(initialHeight, selectedValue) { $0 != $1 }

    input.initializeButtonTap
      .withLatestFrom(selectedValue)
      .drive(with: self, onNext: { owner, value in
        owner.listener?.sendData(item: .text(text: "\(value)"))
        owner.delegate?.sheetInvoke(.onDismiss)
      })
    .disposed(by: disposeBag)
    
    return Output(
      items: items,
      initialHeight: initialHeightIndex,
      isBtnEnabled: isBtnEnabled
    )
  }
}
