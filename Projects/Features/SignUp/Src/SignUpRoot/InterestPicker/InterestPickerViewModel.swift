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

final class InterestTagPickerViewModel: ViewModelType {
  weak var delegate: SignUpCoordinatingActionDelegate?

  struct Input {
    var chipTap: Driver<IndexPath>
    var nextBtnTap: Driver<Void>
  }

  struct Output {
    var chips: Driver<[EmojiType]>
    var isNextBtnEnabled: Driver<Bool>
  }

  private var disposeBag = DisposeBag()

  func transform(input: Input) -> Output {
    let chips = BehaviorRelay<[EmojiType]>(value: [
      .init(idx: 1, name: "그림 그리기", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "반려동물", emojiCode: "U+1F963"),
      .init(idx: 1, name: "패션", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "게임", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "게임", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "게임", emojiCode: "U+1F963"),
      .init(idx: 1, name: "게임", emojiCode: "U+1F963"),
      .init(idx: 1, name: "게임", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "게임", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "게임", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "게임", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "게임", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "게임", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "게임", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "게임", emojiCode: "U+1F3AE"),

        .init(idx: 1, name: "게임", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "다서엇글자", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "네글게임", emojiCode: "U+1F3AE"),

        .init(idx: 1, name: "게임", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "게임", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "게임", emojiCode: "U+1F3AE"),

        .init(idx: 1, name: "세글자", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "네그을자", emojiCode: "U+1F3AE"),
      .init(idx: 1, name: "다섯/글자", emojiCode: "U+1F3AE"),
    ])

    let outputChips = chips.debug("chips")

    let selectedChip = input.chipTap

    input.nextBtnTap
      .drive(with: self) { owner, _ in
        owner.delegate?.invoke(.nextAtGender)
      }.disposed(by: disposeBag)

    return Output(
      chips: chips.asDriver(),
      isNextBtnEnabled: Driver.just(true)
    )
  }
}
