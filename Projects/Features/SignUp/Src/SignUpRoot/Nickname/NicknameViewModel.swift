//
//  NicknameViewModel.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/12.
//

import Foundation

import Core

import RxCocoa
import RxSwift

final class NicknameInputViewModel: ViewModelType {

  weak var delegate: SignUpCoordinatingActionDelegate?

  private var disposeBag = DisposeBag()

  struct Input {
    let viewWillAppear: Driver<Void>
    let nickname: Driver<String>
    let clearBtn: Driver<Void>
    let nextBtn: Driver<Void>
  }

  struct Output {
    let validate: Driver<Bool>
  }

  func transform(input: Input) -> Output {
    let text = input.nickname

    let validate = text.map { !$0.isEmpty }

    input.nextBtn
      .withLatestFrom(text)
      .drive(with: self) { owner, text in
        owner.delegate?.invoke(.nextAtNickname(text))
      }
      .disposed(by: disposeBag)

    return Output(
      validate: validate
    )
  }
}
