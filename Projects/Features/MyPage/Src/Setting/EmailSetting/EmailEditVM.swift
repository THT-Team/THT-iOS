//
//  EmailEditVM.swift
//  MyPageInterface
//
//  Created by Kanghos on 7/29/24.
//

import Foundation

import Core

import RxSwift
import RxCocoa
import MyPageInterface

public final class EmailEdittVM: ViewModelType {
  private let email: String
  private var disposeBag = DisposeBag()

  private let useCase: MyPageUseCaseInterface
  var onComplete: ((String) -> Void)?

  init(email: String, useCase: MyPageUseCaseInterface) {
    self.email = email
    self.useCase = useCase
  }

  enum EmailTextState {
    case empty
    case valid
    case invalid
  }

  public struct Input {
    let emailText: Driver<String>
    let nextBtnTap: Driver<Void>
    let naverBtnTapped: Driver<Void>
    let kakaoBtnTapped: Driver<Void>
    let gmailBtnTapped: Driver<Void>
  }

  public struct Output {
    let buttonState: Driver<Bool>
    let emailTextStatus: Driver<EmailTextState>
    let emailText: Driver<String>
  }

  public func transform(input: Input) -> Output {
    let initialEmail = Driver.just(self.email)

    let text = input.emailText
      .distinctUntilChanged()
      .debounce(.milliseconds(300))

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

    let emailTextStatus = emailValidate

    // TODO: Email 로 로그인 문제 생겼을때 계정 복구 진행하는데 저장하는 api 를 찾을수 없음. 추후 저장로직 개발 필요해 보임
    input.nextBtnTap
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(outputText)
      .flatMapLatest(with: self) { owner, email in
        owner.useCase.updateEmail(email)
          .map { _ in email }
          .asDriver { error in
            print(error.localizedDescription)
            return .empty()
          }
      }
      .drive(with: self, onNext: { owner, email in
        owner.onComplete?(email)
      })
      .disposed(by: disposeBag)

    return Output(
      buttonState: buttonState,
      emailTextStatus: emailTextStatus,
      emailText:  Driver.merge(outputText, initialEmail)
    )
  }
}
