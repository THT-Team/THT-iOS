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

public final class AuthUseCase: AuthUseCaseInterface {
  private let repository: AuthRepositoryInterface
  private let tokenStore: TokenStore

  public init(authRepository: AuthRepositoryInterface, tokenStore: TokenStore) {
    self.repository = authRepository
    self.tokenStore = tokenStore
    TFLogger.domain.debug("AuthUseCase init")
  }
  public func certificate(phoneNumber: String) -> RxSwift.Single<Int> {
    repository.certificate(phoneNumber: phoneNumber)
  }

  public func checkUserExists(phoneNumber: String) -> Single<UserSignUpInfoRes> {
    return repository.checkUserExist(phoneNumber: phoneNumber)
  }

  public func login(phoneNumber: String, deviceKey: String) -> Single<Void> {
    return repository.login(phoneNumber: phoneNumber, deviceKey: deviceKey)
      .flatMap { [weak self] token in
        self?.tokenStore.saveToken(token: token)
        return .just(())
      }
  }

  public func loginSNS(_ request: AuthInterface.UserSNSLoginRequest) -> Single<Void> {
    return repository.loginSNS(request)
      .flatMap { [weak self] token in
        self?.tokenStore.saveToken(token: token)
        return .just(())
      }
  }

  // TODO: token을 어디서 집어넣을 지 생각해볼 것 e,g Authenticator
  public func refresh() -> Single<Void> {
    guard let token = try? tokenStore.getToken() else {
      return .error(AuthError.invalidToken)
    }
    return repository.refresh(token)
      .flatMap { [weak self] token in
        self?.tokenStore.saveToken(token: token)
        return .just(())
      }
  }
}
