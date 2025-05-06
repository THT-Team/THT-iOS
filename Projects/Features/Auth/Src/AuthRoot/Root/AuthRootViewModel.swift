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

public protocol AuthRootOutput: AnyObject {

  var onPhoneNumberAuthFlow: (() -> Void)? { get set }
  var onSignUpFlow: ((PendingUser) -> Void)? { get set }
  var onMainFlow: (() -> Void)? { get set }
  var onInquiryFlow: (() -> Void)? { get set }
  var onError: (() -> Void)? { get set }

  func onPhoneNumberVerified(_ number: String)
}

final class AuthRootViewModel: ViewModelType, AuthRootOutput {
  private let useCase: AuthUseCaseInterface

  public var onPhoneNumberAuthFlow: (() -> Void)?
  public var onSignUpFlow: ((PendingUser) -> Void)?
  public var onMainFlow: (() -> Void)?
  public var onInquiryFlow: (() -> Void)?
  public var onError: (() -> Void)?

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

  let phoneNumberSubject = PublishSubject<String>()

  func transform(input: Input) -> Output {
    let toastPublisher = PublishRelay<String>()
    let buttonTap = input.buttonTap
    let navigation = PublishSubject<AuthNavigation>()
    let errorSubject = PublishSubject<Error>()

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
      .compactMap { AuthType($0) }
      .flatMapLatest(with: self) { owner, type in
        owner.useCase.authenticate(type)
          .asDriver { error in
            errorSubject.onNext(error)
            return .empty()
          }
      }
      .drive(navigation)
      .disposed(by: disposeBag)

    phoneNumberSubject
      .map { AuthType.phoneNumber(number: $0) }
      .withUnretained(self)
      .flatMapLatest { owner, type in
        owner.useCase.authenticate(type)
          .asObservable()
          .catch {
            errorSubject.onNext($0)
            return .empty()
          }
      }
      .bind(to: navigation)
      .disposed(by: disposeBag)

    navigation
      .asDriver { error in
        errorSubject.onNext(error)
        return .empty()
      }
      .drive(with: self) { owner, navigation in
        switch navigation {
        case .main:
          owner.onMainFlow?()
        case let .signUp(userInfo):
          owner.onSignUpFlow?(userInfo)
        }
      }
      .disposed(by: disposeBag)

    input.inquiryTap
      .emit(with: self) { owner, _ in
        owner.onInquiryFlow?()
      }
      .disposed(by: disposeBag)

    errorSubject
      .subscribe(onNext: { error in
          toastPublisher.accept(error.localizedDescription)
      })
      .disposed(by: disposeBag)

    return Output(toast: toastPublisher.asSignal(onErrorSignalWith: .empty()))
  }

  func onPhoneNumberVerified(_ number: String) {
    phoneNumberSubject.onNext(number)
  }
}
