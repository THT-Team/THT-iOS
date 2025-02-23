//
//  AuthService.swift
//  Data
//
//  Created by Kanghos on 6/26/24.
//

import Foundation

import Core
import Domain

import AuthInterface
import SignUpInterface

import Moya
import Alamofire
import RxSwift

/// 유저와 직접 상호작용하는 객체
public final class DefaultAuthService: AuthServiceType {
  private let tokenStore: TokenStore
  private let tokenProvider: TokenProvider

  public init(
    tokenStore: TokenStore,
    tokenProvider: TokenProvider
  ) {
    self.tokenStore = tokenStore
    self.tokenProvider = tokenProvider
    TFLogger.cycle(name: self)
  }

  deinit {
    TFLogger.cycle(name: self)
  }

  public func clearToken() {
    tokenStore.clearToken()
  }

  public func signUp(_ user: PendingUser, contacts: [ContactType], urls: [String]) -> Single<Token> {
    guard
      let deviceKey = UserDefaultRepository.shared.fetch(for: .deviceKey, type: String.self),
      let request = user.toRequest(contacts: contacts, deviceKey: deviceKey, imageURL: urls)
    else {
      return .error(SignUpError.invalidRequest)
    }

    return tokenProvider.signUp(request)
      .flatMap { [unowned self] token in
        UserDefaultRepository.shared.remove(key: .pendingUser)
        UserDefaultRepository.shared.save(user.phoneNumber, key: .phoneNumber)
        self.tokenStore.saveToken(token: token)
        return .just(token)
      }
      .flatMap { [unowned self] token in
        user.snsUserInfo.snsType != .normal
        ? self.signUpSNS(user.snsUserInfo)
        : .just(token)
      }
  }

  public func signUpSNS(_ user: SNSUserInfo) -> Single<Token> {
    UserDefaultRepository.shared.remove(key: .pendingUser)
    UserDefaultRepository.shared.save(user.phoneNumber, key: .phoneNumber)
    return tokenProvider.signUpSNS(SNSUserInfo.SignUpRequest(info: user))
  }

  public func needAuth() -> Bool {
    return tokenStore.getToken() == nil
  }

  public func login() -> Single<Token> {
    guard
      let phoneNumber = UserDefaultRepository.shared.fetch(for: .phoneNumber, type: String.self),
      let deviceKey = UserDefaultRepository.shared.fetch(for: .deviceKey, type: String.self)
    else {
      return .error(AuthError.tokenNotFound)
    }
    return tokenProvider.login(phoneNumber: phoneNumber, deviceKey: deviceKey)
      .flatMap { [unowned self] token in
        self.tokenStore.saveToken(token: token)
        return .just(token)
      }
  }

  public func loginSNS(_ user: SNSUserInfo) -> Single<Token> {
    guard
      let deviceKey = UserDefaultRepository.shared.fetch(for: .deviceKey, type: String.self)
    else {
      return .error(AuthError.tokenNotFound)
    }
    return tokenProvider.loginSNS(SNSUserInfo.LoginRequest(info: user, deviceKey: deviceKey))
      .flatMap { [unowned self] token in
      self.tokenStore.saveToken(token: token)
      return .just(token)
    }
  }

  public func getToken() -> Token? {
    tokenStore.getToken()
  }

  public func updateDeviceToken(_ token: String) -> Single<Void> {
    tokenProvider.updateDeviceToken(token)
  }
}

public class EnvironmentProvider {
  private let _environemnt: RepositoryEnvironment

  public var environment: RepositoryEnvironment {
    _environemnt
  }
  public let tokenRefresher: TokenRefresher
  public let tokenStore: TokenStore

  public init(_ environment: AppEnvironment) {
    self.tokenRefresher = DefaultTokenRefresher(environment)
    self.tokenStore = UserDefaultTokenStore.shared

    switch environment {
    case .debug:
      self._environemnt = .debug
    case .release:
      self._environemnt = .release(EnvironmentProvider.create(
        refresher: tokenRefresher,
        tokenStore: tokenStore))
    }
  }

  public static func create(
    refresher: TokenRefresher,
    tokenStore: TokenStore
  ) -> Moya.Session {
    let authenticator = OAuthAuthenticator(
      refresher: refresher, tokenStore: tokenStore)
    let interceptor = AuthenticationInterceptor(
      authenticator: authenticator,
      credential: tokenStore.getToken()?.toAuthOCredential())
    return Session(interceptor: interceptor)
  }
}
