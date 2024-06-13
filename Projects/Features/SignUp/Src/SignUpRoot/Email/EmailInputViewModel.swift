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

final class EmailInputViewModel: ViewModelType {
  enum EmailTextState {
    case empty
    case valid
    case invalid
  }

  struct Input {
    let viewDidAppear: Driver<Void>
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

  weak var delegate: SignUpCoordinatingActionDelegate?

  private var disposeBag = DisposeBag()
  private let userInfoUseCase: UserInfoUseCaseInterface

  init(userInfoUseCase: UserInfoUseCaseInterface) {
    self.userInfoUseCase = userInfoUseCase
  }

  func transform(input: Input) -> Output {

    let userinfo = input.viewDidAppear
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.userInfoUseCase.fetchUserInfo()
          .catchAndReturn(UserInfo(phoneNumber: ""))
          .asObservable()
      }
      .asDriverOnErrorJustEmpty()

    let initialEmail = userinfo
      .map { $0.email ?? "" }

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

    let updatedUserInfo = Driver.combineLatest(userinfo, outputText) { userinfo, email in
      var userinfo = userinfo
      userinfo.email = email
      return userinfo
    }

    // TODO: Email 로 로그인 문제 생겼을때 계정 복구 진행하는데 저장하는 api 를 찾을수 없음. 추후 저장로직 개발 필요해 보임
    input.nextBtnTap
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(updatedUserInfo)
      .drive(with: self, onNext: { owner, userinfo in
        owner.userInfoUseCase.updateUserInfo(userInfo: userinfo)
        owner.delegate?.invoke(.nextAtEmail)
      })
      .disposed(by: disposeBag)

    return Output(
      buttonState: buttonState,
      warningLblState: warningLblState,
      emailTextStatus: emailTextStatus,
      emailText:  Driver.merge(outputText, initialEmail)
    )
  }
}
