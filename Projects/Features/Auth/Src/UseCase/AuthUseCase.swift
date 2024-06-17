//
//  AuthUseCase.swift
//  AuthInterface
//
//  Created by Kanghos on 5/27/24.
//

import Foundation
import AuthInterface
import RxSwift
import Core

import Core

public final class AuthUseCase: AuthUseCaseInterface {
  private let repository: AuthRepositoryInterface

  public init(authRepository: AuthRepositoryInterface) {
    self.repository = authRepository
  }

  deinit {
    TFLogger.cycle(name: self)
  }
  public func certificate(phoneNumber: String) -> RxSwift.Single<Int> {
    repository.certificate(phoneNumber: phoneNumber)
  }

  public func checkUserExists(phoneNumber: String) -> Single<UserSignUpInfoRes> {
    return repository.checkUserExist(phoneNumber: phoneNumber)
  }

  public func login(phoneNumber: String, deviceKey: String) -> Single<Void> {
    return repository.login(phoneNumber: phoneNumber, deviceKey: deviceKey)
      .map { _ in }
  }

  public func loginSNS(_ request: AuthInterface.UserSNSLoginRequest) -> Single<Void> {
    return repository.loginSNS(request)
      .map { _ in }
  }

  // TODO: token을 어디서 집어넣을 지 생각해볼 것 e,g Authenticator
  public func refresh() -> Single<Void> {
    return repository.refresh()
      .map { _ in }
  }
}
