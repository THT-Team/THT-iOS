//
//  EmailInputViewModel.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/06.
//

import Foundation

import Core

import RxSwift
import RxCocoa

final class EmailInputViewModel: ViewModelType {
  enum EmailTextState {
    case empty
    case valid
    case invalid
  }

  weak var delegate: SignUpCoordinatingActionDelegate?
  private var disposeBag = DisposeBag()
  private let initialEmail: String?

  struct Input {
    let emailText: Driver<String>
    let clearBtnTapped: Driver<Void>
    let nextBtnTap: Driver<Void>
    let naverBtnTapped: Driver<Void>
    let kakaoBtnTapped: Driver<Void>
    let gmailBtnTapped: Driver<Void>
  }

  struct Output {
    let buttonState: Driver<Bool>
    let warningLblState: Driver<Bool>
    let emailTextStatus: Driver<EmailTextState>
    let emailText: Driver<String>
  }

  init(email: String?) {
    self.initialEmail = email
  }

  func transform(input: Input) -> Output {
    let initialEmail = BehaviorRelay<String?>(value: self.initialEmail)

    let text = input.emailText
      .distinctUntilChanged()
      .debounce(.milliseconds(300))
      .debug()

    let autoComplete = Driver
      .merge([input.naverBtnTapped.map { "@naver.com" },
              input.gmailBtnTapped.map { "@gmail.com" },
              input.kakaoBtnTapped.map { "@kakao.com" }])
      .withLatestFrom(text) { $1 + $0 }

    let outputText = Driver.merge(text, autoComplete, input.clearBtnTapped.map { "" })

    let emailValidate = outputText
      .map {
        if $0.isEmpty {
          return EmailTextState.empty
        } else {
          if $0.emailValidation() {
            return EmailTextState.valid
          } else {
            return EmailTextState.invalid
          }
        }
      }
      .debug("emailValidate")

    let buttonState = emailValidate
      .map {
        switch $0 {
        case .empty, .invalid:
          return false
        case .valid:
          return true
        }
      }

    let warningLblState = emailValidate
      .map {
        switch $0 {
        case .empty, .valid:
          return true
        case .invalid:
          return false
        }
      }

    let emailTextStatus = emailValidate.asDriver(onErrorJustReturn: .empty)

    // TODO: Email 로 로그인 문제 생겼을때 계정 복구 진행하는데 저장하는 api 를 찾을수 없음. 추후 저장로직 개발 필요해 보임
    input.nextBtnTap
      .withLatestFrom(outputText)
      .drive(with: self, onNext: { owner, email in
        owner.delegate?.invoke(.nextAtEmail(email: email))
      })
      .disposed(by: disposeBag)

    return Output(
      buttonState: buttonState,
      warningLblState: warningLblState,
      emailTextStatus: emailTextStatus,
      emailText:  Driver.merge(outputText, initialEmail.asDriver().compactMap { $0 })
    )
  }
}
