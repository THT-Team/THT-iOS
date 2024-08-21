//
//  IntroduceInputViewModel.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/24.
//

import Foundation

import Core

import RxCocoa
import RxSwift
import SignUpInterface

final class IntroduceInputViewModel: BasePenddingViewModel, ViewModelType {

  struct Input {
    let nextBtn: Driver<Void>
    let introduceText: Driver<String>
  }

  struct Output {
    let initialValue: Driver<String?>
    let isEnableNextBtn: Driver<Bool>
  }

  func transform(input: Input) -> Output {

    let initialValue = Driver.just(self.pendingUser.introduction).filter { $0 != nil }

    let isEnableNextBtn = input.introduceText
      .map { _ in true }

    input.nextBtn
      .withLatestFrom(isEnableNextBtn)
      .filter{ $0 }
      .withLatestFrom(input.introduceText)
      .drive(with: self, onNext: { owner, introduce in
        owner.pendingUser.introduction = introduce
        owner.useCase.savePendingUser(owner.pendingUser)
        owner.delegate?.invoke(.nextAtIntroduce, owner.pendingUser)
      })
      .disposed(by: disposeBag)

    return Output(
      initialValue: initialValue,
      isEnableNextBtn: isEnableNextBtn
    )
  }
}
