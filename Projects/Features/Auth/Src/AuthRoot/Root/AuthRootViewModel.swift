//
//  SignUpViewModel.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/22.
//

import Foundation

import RxSwift
import RxCocoa
import AuthInterface

import Core
import Domain

final class AuthRootViewModel: ViewModelType {
  private let useCase: AuthUseCaseInterface

  public var onPhoneNumberVerified: ((String) -> Void)?

  public var onPhoneNumberAuthFlow: (() -> Void)?
  public var onSignUpFlow: ((SNSUserInfo) -> Void)?
  public var onMainFlow: (() -> Void)?
  public var onInquiryFlow: (() -> Void)?

  struct Input {
    let buttonTap: Driver<SNSType>
    let inquiryTap: Signal<Void>
  }

  struct Output {
    let toast: Signal<String>
  }

  var disposeBag: DisposeBag = DisposeBag()

  init(useCase: AuthUseCaseInterface) {
    self.useCase = useCase
  }

  // error toast
  //
  let phoneNumberVerifiedSubject = PublishSubject<String>()
  func transform(input: Input) -> Output {
    let toastPublisher = PublishRelay<String>()
    let buttonTap = input.buttonTap

    let snsUserInfoSubject = PublishSubject<SNSUserInfo>()

    buttonTap
      .throttle(.milliseconds(500), latest: false)
      .flatMapLatest(with: self) { owner, type -> Driver<SNSUserInfo> in
        owner.useCase.auth(type)
          .asDriver { error in
            toastPublisher.accept(error.localizedDescription)
            return .empty()
          }
      }
      .drive(snsUserInfoSubject)
      .disposed(by: disposeBag)

    snsUserInfoSubject
      .subscribe(with: self, onNext: { owner, userInfo in
        guard let phoneNumber = userInfo.phoneNumber else {
          owner.onPhoneNumberAuthFlow?()
          return
        }
        owner.phoneNumberVerifiedSubject.onNext(phoneNumber)
      })
      .disposed(by: disposeBag)


//    phoneNumberVerifiedSubject
//      .withLatestFrom(snsUserInfoSubject) { ($0, $1) }
//
    Observable.zip(phoneNumberVerifiedSubject, snsUserInfoSubject)
      .withUnretained(self)
      .flatMap { owner, info -> Single<AuthResult> in
        let (phoneNumber, snsUserInfo) = info
        var userInfo = snsUserInfo
        userInfo.phoneNumber = phoneNumber
        return owner.useCase.authenticate(userInfo: userInfo)
      }
      .withUnretained(self)
      .flatMap { owner, result -> Observable<AuthNavigation> in
        owner.useCase.processResult(result)
          .asObservable()
      }
      .asDriverOnErrorJustEmpty()
      .drive(with: self) { owner, navigation in
        switch navigation {
        case .main:
          owner.onMainFlow?()
        case let .signUp(userInfo):
          owner.onSignUpFlow?(userInfo)
        case .phoneNumber(_):
          break
        }
      }
      .disposed(by: disposeBag)

    input.inquiryTap
      .emit(with: self) { owner, _ in
        owner.onInquiryFlow?()
      }
      .disposed(by: disposeBag)

    return Output(toast: toastPublisher.asSignal(onErrorSignalWith: .empty()))
  }

  func onPhoneNumberVerified(_ number: String) {
    phoneNumberVerifiedSubject.onNext(number)
  }
}

enum UserResult {
  case signUp(SNSUserInfo)
  case login(SNSUserInfo)
}
