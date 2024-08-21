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
import KakaoSDKAuth
import KakaoSDKUser

import Core

final class AuthRootViewModel: ViewModelType {
  private let useCase: AuthUseCaseInterface

  struct Input {
    let buttonTap: Driver<SNSType>
    let inquiryTap: Signal<Void>
  }

  struct Output {

  }

  weak var delegate: AuthCoordinatingActionDelegate?

  var disposeBag: DisposeBag = DisposeBag()

  init(useCase: AuthUseCaseInterface) {
    self.useCase = useCase
  }

  func transform(input: Input) -> Output {
    input.buttonTap
      .throttle(.milliseconds(500), latest: false)
      .debug("SNS tap")
      .flatMapLatest(with: self) { owner, sns -> Driver<AuthType> in
        return owner.useCase.auth(sns)
          .asDriver(onErrorRecover: { error in
            TFLogger.domain.error("\(error.localizedDescription)")
            return .empty()
          })
      }
      .drive(with: self, onNext: { owner, authType in
        owner.delegate?.invoke(.tologinType(authType))
      })
      .disposed(by: disposeBag)

    input.inquiryTap
      .debug()
      .emit(with: self) { owner, _ in
        owner.delegate?.invoke(.inquiry)
      }.disposed(by: disposeBag)

    return Output()
  }
}
