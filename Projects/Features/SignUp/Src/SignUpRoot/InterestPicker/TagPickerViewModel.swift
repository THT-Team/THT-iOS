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

final class TagPickerViewModel: ViewModelType {
  private let actionType: SignUpCoordinatingAction
  weak var delegate: SignUpCoordinatingActionDelegate?

  struct Input {
    var chipTap: Driver<IndexPath>
    var nextBtnTap: Driver<Void>
  }

  struct Output {
    var chips: Driver<[InputTagItemViewModel]>
    var isNextBtnEnabled: Driver<Bool>
  }

  private var disposeBag = DisposeBag()

  init(action: SignUpCoordinatingAction) {
    self.actionType = action
  }

  func transform(input: Input) -> Output {
    let dummyEmojis:[EmojiType] = [
      EmojiType(idx: 0, name: "게임", emojiCode: "#2425fa"),
      EmojiType(idx: 0, name: "게임", emojiCode: "#2425fa"),
      EmojiType(idx: 0, name: "게임", emojiCode: "#2425fa"),
      EmojiType(idx: 0, name: "게임", emojiCode: "#2425fa"),
      EmojiType(idx: 0, name: "게임", emojiCode: "#2425fa"),
    ]

    let chips = BehaviorRelay<[InputTagItemViewModel]>(value: dummyEmojis.map { .init(item: $0, isSelected: false) })

    let selectedItemArray = input.chipTap
      .scan([]) { (prev, indexPath) -> [IndexPath] in
        var updatedSelectedItems = prev
        let selectedItemCount = prev.count

        // 이미 선택된 셀일 때
        if updatedSelectedItems.contains(indexPath) {
          updatedSelectedItems.removeAll { $0 == indexPath }
        } else if selectedItemCount < 3 { // 선택된게 3개 미만일 때
          updatedSelectedItems.append(indexPath)
        }

        return updatedSelectedItems
      }
      .startWith([])

    let updatedChips = selectedItemArray
      .map { selectedItems in
        chips.value.enumerated()
          .map { index, item in
            InputTagItemViewModel(
              item: item.emojiType, isSelected: selectedItems.contains(IndexPath(item: index, section: 0))
            )
          }
      }

    let isNextBtnEnabled = selectedItemArray
      .map { $0.count == 3 }

    input.nextBtnTap
      .withLatestFrom(selectedItemArray) {
        $1.map { chips.value[$0.item].emojiType.idx }
      }
      .drive(with: self, onNext: { owner, items in
        switch owner.actionType {
        case .nextAtInterest:
          owner.delegate?.invoke(.nextAtInterest(items))
        case .nextAtIdealType:
          owner.delegate?.invoke(.nextAtIdealType(items))
        default: break
        }
      })
      .disposed(by: disposeBag)

    return Output(
      chips: updatedChips,
      isNextBtnEnabled: isNextBtnEnabled
    )
  }
}
