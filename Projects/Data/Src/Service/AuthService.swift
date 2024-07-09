//
//  AuthService.swift
//  Data
//
//  Created by Kanghos on 6/26/24.
//

import Foundation

import RxSwift

import AuthInterface
import SignUpInterface

import Moya
import Alamofire

public protocol SessionFactoryType {
  func createSession() -> Session
}

public protocol AuthServiceType: SessionFactoryType {
  var cachedToken: Token? { get set }

  func clearToken()
  func refreshToken(completion: @escaping (Result<Token, Error>) -> Void)
  func refresh() -> Single<Token>
  func login(phoneNumber: String, deviceKey: String) -> Single<Token>
  func loginSNS(_ userSNSLoginRequest: UserSNSLoginRequest) -> Single<Token>
  func signUp(_ signUpRequest: SignUpReq) -> Single<Token>
}

public final class DefaultAuthService: AuthServiceType {
  private let tokenStore: TokenStore
  private let tokenProvider: TokenProvider
  public var cachedToken: Token?
  private lazy var authenticator: AuthenticationInterceptor<OAuthAuthenticator> = {
    createInterceptor()
  }()

  public init(tokenStore: TokenStore = UserDefaultTokenStore(), tokenProvider: TokenProvider = DefaultTokenProvider()) {
    self.tokenStore = tokenStore
    self.tokenProvider = tokenProvider
  }

  public func clearToken() {
    tokenStore.clearToken()
  }

  public func createSession() -> Session {
    return Session(interceptor: authenticator)
  }

  public func signUp(_ signUpRequest: SignUpReq) -> Single<Token> {
    tokenProvider.signUp(signUpRequest)
      .flatMap { [unowned self] token in
        self.tokenStore.saveToken(token: token)
        return .just(token)
      }
  }

  public func refreshToken(completion: @escaping (Result<Token, Error>) -> Void) {
    guard let token = tokenStore.getToken() else {
      completion(.failure(AuthError.tokenNotFound))
      return
    }
    tokenProvider.refreshToken(token: token) { [weak self] result in
      switch result {
      case .success(let refreshed):
        self?.tokenStore.saveToken(token: refreshed)
        self?.cachedToken = refreshed
        completion(.success(refreshed))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  public func refresh() -> Single<Token> {
    guard let token = tokenStore.getToken() else {
      return .error(AuthError.tokenNotFound)
    }
    return tokenProvider.refresh(token: token)
      .flatMap { [unowned self] token in
        self.tokenStore.saveToken(token: token)
        self.cachedToken = token
        return .just(token)
      }
  }

  public func login(phoneNumber: String, deviceKey: String) -> Single<Token> {
    tokenProvider.login(phoneNumber: phoneNumber, deviceKey: deviceKey)
      .flatMap { [unowned self] token in
        self.tokenStore.saveToken(token: token)
        self.cachedToken = token
        return .just(token)
      }
  }

  public func loginSNS(_ userSNSLoginRequest: UserSNSLoginRequest) -> Single<Token> {
    tokenProvider.loginSNS(userSNSLoginRequest)
      .flatMap { [unowned self] token in
        self.tokenStore.saveToken(token: token)
        self.cachedToken = token
        return .just(token)
      }
  }

  private func createInterceptor() -> AuthenticationInterceptor<OAuthAuthenticator> {
    let credential = tokenStore.getToken()?.toAuthOCredential() ?? OAuthCredential(accessToken: "", accessTokenExpiresIn: Date().timeIntervalSince1970)

    let authenticator = OAuthAuthenticator(authService: self)
    let intercepter = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
    return intercepter
  }
}
