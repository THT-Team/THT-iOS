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
  func transform(input: Input) -> Output {
    let toastPublisher = PublishRelay<String>()
    let buttonTap = input.buttonTap
    let phoneNumberVerifiedSubject = PublishSubject<String>()

    let snsUserInfoSubject = PublishSubject<SNSUserInfo>()
    let checkRegisterPublisher = PublishSubject<SNSUserInfo>()

    self.onPhoneNumberVerified = { phoneNumber in
      phoneNumberVerifiedSubject.onNext(phoneNumber)
    }

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
        phoneNumberVerifiedSubject.onNext(phoneNumber)
      })
      .disposed(by: disposeBag)

    Observable.combineLatest(phoneNumberVerifiedSubject, snsUserInfoSubject)
      .withUnretained(self)
      .flatMap { owner, info -> Single<AuthResult> in
        let (phoneNumber, snsUserInfo) = info
        return owner.useCase.authenticate(userInfo: snsUserInfo)
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
}

enum UserResult {
  case signUp(SNSUserInfo)
  case login(SNSUserInfo)
}
