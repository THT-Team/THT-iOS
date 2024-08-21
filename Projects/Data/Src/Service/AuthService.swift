//
//  AuthService.swift
//  Data
//
//  Created by Kanghos on 6/26/24.
//

import Foundation

import Core

import AuthInterface
import SignUpInterface

import Moya
import Alamofire
import RxSwift

public final class DefaultAuthService: AuthServiceType {
  private let tokenStore: TokenStore
  private let tokenProvider: TokenProvider
  private let sessionSubject = PublishSubject<Session>()

  private var authenticator: AuthenticationInterceptor<OAuthAuthenticator>?

  public var cachedToken: Token? {
    didSet {
      let session = Session(interceptor: createInterceptor())
      sessionSubject.onNext(session)
      self.session = session
    }
  }

  private var session: Session?

  public init(tokenStore: TokenStore = UserDefaultTokenStore(), tokenProvider: TokenProvider = DefaultTokenProvider()) {
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

  public func createSession() -> Session {
    if let session = self.session {
      return session
    }
    self.authenticator = createInterceptor()
    let session = Session(interceptor: self.authenticator)
    self.session = session
    return session
  }

  public func signUp(_ signUpRequest: SignUpReq) -> Single<Token> {
    tokenProvider.signUp(signUpRequest)
      .flatMap { [unowned self] token in
        self.tokenStore.saveToken(token: token)
        self.cachedToken = token
        self.authenticator?.credential = token.toAuthOCredential()
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
        self?.authenticator?.credential = token.toAuthOCredential()
        completion(.success(refreshed))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  public func refresh() -> Single<Token> {
    return .create { [weak self] observer in
      self?.refreshToken { result in
        switch result {
        case .success(let success):
          observer(.success(success))
        case .failure(let failure):
          observer(.failure(failure))
        }
      }
      return Disposables.create { }
    }
  }

  public func needAuth() -> Bool {
    return tokenStore.getToken() == nil
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

    let authenticator = OAuthAuthenticator(tokenProvider: tokenProvider)
    let intercepter = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
    return intercepter
  }

  public func sessionPublisher() -> Single<Session> {
    sessionSubject.asSingle()
  }
}

//extension DefaultAuthService {
//  public func updateSession(credential: OAuthCredential) {
//    let authenticator = OAuthAuthenticator(tokenProvider: tokenProvider)
//    let interceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
//
//  }
//}
