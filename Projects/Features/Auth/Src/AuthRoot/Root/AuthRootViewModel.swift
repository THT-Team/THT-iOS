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

public protocol AuthRootOutput {
  var onPhoneNumberVerified: ((String) -> Void)? { get set }

  var onPhoneNumberAuthFlow: (() -> Void)? { get set }
  var onSignUpFlow: ((SNSUserInfo) -> Void)? { get set }
  var onMainFlow: (() -> Void)? { get set }
  var onInquiryFlow: (() -> Void)? { get set }

  func onPhoneNumberVerified(_ number: String)
}

final class AuthRootViewModel: ViewModelType, AuthRootOutput {
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

  let snsUserInfoSubject = PublishSubject<SNSUserInfo>()

  func transform(input: Input) -> Output {
    let toastPublisher = PublishRelay<String>()
    let buttonTap = input.buttonTap


    let btnTap = buttonTap
      .throttle(.milliseconds(500), latest: false)

    btnTap
      .filter { $0 == .normal }
      .drive(with: self, onNext: { owner, type in
        owner.onPhoneNumberAuthFlow?()
      })
      .disposed(by: disposeBag)

    btnTap
      .filter { $0 != .normal }
      .flatMapLatest(with: self) { owner, snsType in
        owner.useCase.auth(snsType)
          .asDriver { error in
            toastPublisher.accept(error.localizedDescription)
            return .empty()
          }
      }
      .drive(snsUserInfoSubject)
      .disposed(by: disposeBag)

    snsUserInfoSubject
      .withUnretained(self)
      .flatMap { owner, info -> Single<AuthResult> in
        owner.useCase.authenticate(userInfo: info)
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
    snsUserInfoSubject.onNext(.init(snsType: .normal, id: "", email: nil, phoneNumber: number))
  }
}

enum UserResult {
  case signUp(SNSUserInfo)
  case login(SNSUserInfo)
}
