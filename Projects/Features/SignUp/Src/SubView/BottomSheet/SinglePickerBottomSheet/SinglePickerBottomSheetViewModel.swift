//
//  SinglePickerBottomSheetViewModel.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import Foundation

import SignUpInterface

import RxSwift
import RxCocoa

import Core

class SinglePickerBottomSheetViewModel: ViewModelType {
//  private let filterType: Item
  private let initialValue: BottomSheetValueType

  weak var listener: BottomSheetListener?
  weak var delegate: BottomSheetActionDelegate?

  private var disposeBag = DisposeBag()

  init(initialValue: BottomSheetValueType) {
    self.initialValue = initialValue
  }

  public struct Input {
    let selectedItem: Driver<(row: Int, component: Int)>
    let initializeButtonTap: Driver<Void>
  }

  public struct Output {
    let items: Driver<[[Int]]>
  }

  public func transform(input: Input) -> Output {
    let loadTrigger = Observable.just(Void())
    let outputItems = loadTrigger
      .map { _ -> [[Int]] in
        let heightArray = Array(145...200)
        return [heightArray]
      }

    let selectedValue = input.selectedItem
      .asObservable()
      .withLatestFrom(outputItems) { picker, items in
          return items[picker.component][picker.row]
      }.map { String($0) }

    input.initializeButtonTap
      .withLatestFrom(selectedValue.asDriverOnErrorJustEmpty())
      .drive(with: self, onNext: { owner, value in
        owner.listener?.sendData(item: .text(text: value))
        owner.delegate?.sheetInvoke(.onDismiss)
      })
    .disposed(by: disposeBag)

    return Output(
      items: outputItems.asDriverOnErrorJustEmpty()
    )
  }
}
