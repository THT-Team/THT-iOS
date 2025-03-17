//
//  AuthService.swift
//  Data
//
//  Created by Kanghos on 6/26/24.
//

import Foundation

import Core
import Domain

import Moya
import Alamofire
import RxSwift

/// 유저와 직접 상호작용하는 객체
public final class TokenService: TokenServiceType {
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

  public func clear() {
    tokenStore.clearToken()
  }

  public func signUp(_ user: PendingUser, contacts: [ContactType], urls: [String]) -> Single<Void> {
    guard
      let request = user.toRequest(contacts: contacts, deviceKey: "-1", imageURL: urls)
    else {
      return .error(SignUpError.invalidRequest)
    }

    return tokenProvider.signUp(request)
      .do(onSuccess: { [weak self] token in
        UserDefaultRepository.shared.remove(key: .pendingUser)
        UserDefaultRepository.shared.save(user.phoneNumber, key: .phoneNumber)
        self?.tokenStore.saveToken(token: token)
      })
      .flatMap { [unowned self] _ in
        user.snsUserInfo.snsType != .normal
        ? self.signUpSNS(user.snsUserInfo)
        : .just(())
      }
  }

  public func signUpSNS(_ user: SNSUserInfo) -> Single<Void> {
    UserDefaultRepository.shared.remove(key: .pendingUser)
    UserDefaultRepository.shared.save(user.phoneNumber, key: .phoneNumber)
    return tokenProvider.signUpSNS(SNSUserInfo.SignUpRequest(info: user))
      .flatMap { [weak self] token in
        self?.tokenStore.saveToken(token: token)
        return .just(())
      }
  }

  public func login() -> Single<Void> {
    guard
      let phoneNumber = UserDefaultRepository.shared.fetch(for: .phoneNumber, type: String.self)
    else {
      return .error(AuthError.tokenNotFound)
    }
    return tokenProvider.login(phoneNumber: phoneNumber, deviceKey: "-1")
      .flatMap { [weak self] token in
        self?.tokenStore.saveToken(token: token)
        return .just(())
      }
  }

  public func loginSNS(_ user: SNSUserInfo) -> Single<Void> {
    tokenProvider.loginSNS(SNSUserInfo.LoginRequest(info: user, deviceKey: "-1"))
      .flatMap { [unowned self] token in
      self.tokenStore.saveToken(token: token)
      return .just(())
    }
  }

  public func getToken() -> Token? {
    tokenStore.getToken()
  }

  public func refreshToken() async throws -> Token {
    guard let token = tokenStore.getToken() else { throw AuthError.tokenNotFound }
    return try await tokenProvider.refresh(token)
  }
}
