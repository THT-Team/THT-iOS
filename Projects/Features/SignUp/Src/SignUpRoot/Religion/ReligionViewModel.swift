//
//  ReligionViewModel.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation

import Core

import RxSwift
import RxCocoa
import Domain

final class ReligionPickerViewModel: ViewModelType {
  weak var delegate: SignUpCoordinatingActionDelegate?

  struct Input {
    var chipTap: Driver<IndexPath>
    var nextBtnTap: Driver<Void>
  }

  struct Output {
    var chips: Driver<[(String, Bool)]>
    var isNextBtnEnabled: Driver<Bool>
  }

  private var disposeBag = DisposeBag()

  func transform(input: Input) -> Output {
    let dummy :[String] = [
      "무교", "기독교", "불교",
      "천주교", "원불교", "기타"
    ]

    let chips = BehaviorRelay<[String]>(value: dummy)

    let selectedItem = input.chipTap
      .scan([]) { (prev, indexPath) -> [IndexPath] in
        return [indexPath]
      }
      .startWith([])

    let updatedChips = selectedItem
      .map { selectedItems in
        chips.value.enumerated()
          .map { index, item in
            (item, selectedItems.contains(IndexPath(item: index, section: 0))
            )
          }
      }

    let isNextBtnEnabled = selectedItem
      .map { $0.count == 1 }

    input.nextBtnTap
      .withLatestFrom(isNextBtnEnabled)
      .filter { $0 }
      .withLatestFrom(selectedItem) {
        $1.map { chips.value[$0.item] }
      }
      .drive(with: self, onNext: { owner, items in
        owner.delegate?.invoke(.nextAtReligion(.buddhism))
        })
      .disposed(by: disposeBag)

    return Output(
      chips: updatedChips,
      isNextBtnEnabled: isNextBtnEnabled
    )
  }
}
