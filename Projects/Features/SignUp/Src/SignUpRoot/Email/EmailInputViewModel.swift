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
import SignUpInterface

final class EmailInputViewModel: BasePenddingViewModel, ViewModelType {
  enum EmailTextState {
    case empty
    case valid
    case invalid
  }

  struct Input {
    let viewDidAppear: Driver<Void>
    let emailText: Driver<String>
    let nextBtnTap: Driver<Void>
    let naverBtnTapped: Driver<Void>
    let kakaoBtnTapped: Driver<Void>
    let gmailBtnTapped: Driver<Void>
    let backButtonTap: Signal<Void>
  }

  struct Output {
    let buttonState: Driver<Bool>
    let warningLblState: Driver<Bool>
    let emailTextStatus: Driver<EmailTextState>
    let emailText: Driver<String>
  }

  func transform(input: Input) -> Output {
    let initialEmail = Driver.just(self.pendingUser.email ?? "")

    let text = input.emailText
      .distinctUntilChanged()
      .debounce(.milliseconds(300))
      .debug()

    let autoComplete = Driver
      .merge([input.naverBtnTapped.map { "@naver.com" },
              input.gmailBtnTapped.map { "@gmail.com" },
              input.kakaoBtnTapped.map { "@kakao.com" }])
      .withLatestFrom(text) { domain, text in
        var field = text
        guard let index = field.firstIndex(of: "@") else { return text + domain }
        field.removeSubrange(index..<field.endIndex)
        return field + domain
      }

    let outputText = Driver.merge(text, autoComplete)

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
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(outputText)
      .drive(with: self, onNext: { owner, email in
        owner.pendingUser.email = email
        owner.useCase.savePendingUser(owner.pendingUser)
        owner.delegate?.invoke(.nextAtEmail, owner.pendingUser)
      })
      .disposed(by: disposeBag)

    input.backButtonTap
      .throttle(.milliseconds(500), latest: false)
      .emit(with: self) { owner, _ in
        owner.delegate?.invoke(.backAtEmail, owner.pendingUser)
      }.disposed(by: disposeBag)

    return Output(
      buttonState: buttonState,
      warningLblState: warningLblState,
      emailTextStatus: emailTextStatus,
      emailText:  Driver.merge(outputText, initialEmail)
    )
  }
}
