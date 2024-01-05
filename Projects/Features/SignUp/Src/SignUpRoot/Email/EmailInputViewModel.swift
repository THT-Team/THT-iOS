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

protocol EmailInputDelegate: AnyObject {
  func emailNextButtonTap()
}

final class EmailInputViewModel: ViewModelType {
  enum EmailTextState {
    case empty
    case valid
    case invalid
  }

  weak var delegate: EmailInputDelegate?
  
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
    let buttonTappedResult: Driver<Void>
    let emailText: Driver<String>
  }

  func transform(input: Input) -> Output {
    let text = input.emailText
    let autoComplete = Driver
      .merge([input.naverBtnTapped.map { "@naver.com" },
              input.gmailBtnTapped.map { "@gmail.com" },
              input.kakaoBtnTapped.map { "@kakao.com" }])
      .withLatestFrom(text) { $1 + $0 }

    let outputText = Driver.merge(text, autoComplete, input.clearBtnTapped.map { "" })

    let emailValidate = outputText
      .debug("emailValidate")
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
      .asObservable()

    let buttonState = emailValidate
      .map {
        switch $0 {
        case .empty, .invalid:
          return false
        case .valid:
          return true
        }
      }
      .asDriver(onErrorJustReturn: false)

    let warningLblState = emailValidate
      .map {
        switch $0 {
        case .empty, .valid:
          return true
        case .invalid:
          return false
        }
      }
      .asDriver(onErrorJustReturn: false)

    let emailTextStatus = emailValidate.asDriver(onErrorJustReturn: .empty)

    // TODO: Email 로 로그인 문제 생겼을때 계정 복구 진행하는데 저장하는 api 를 찾을수 없음. 추후 저장로직 개발 필요해 보임
    let buttonTappedResult = input.nextBtnTap
      .do(onNext: { [weak self] in
        self?.delegate?.emailNextButtonTap()
      })

    return Output(
      buttonState: buttonState,
      warningLblState: warningLblState,
      emailTextStatus: emailTextStatus,
      buttonTappedResult: buttonTappedResult,
      emailText: outputText
    )
  }
}
