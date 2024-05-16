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

final class IntroduceInputViewModel: ViewModelType {

  struct Input {
    let nextBtn: Driver<Void>
    let introduceText: Driver<String>
  }

  struct Output {
    let isEnableNextBtn: Driver<Bool>
  }

  weak var delegate: SignUpCoordinatingActionDelegate?
  private let disposeBag = DisposeBag()

  func transform(input: Input) -> Output {

    let isEnableNextBtn = input.introduceText
      .map { !$0.isEmpty && $0.count < 201 }
    
    input.nextBtn
      .withLatestFrom(isEnableNextBtn)
      .filter{ $0 }
      .withLatestFrom(input.introduceText)
      .drive(with: self, onNext: { owner, text in
        owner.delegate?.invoke(.nextAtIntroduce(text))
      })
      .disposed(by: disposeBag)


    return Output(
      isEnableNextBtn: isEnableNextBtn
    )
  }
}