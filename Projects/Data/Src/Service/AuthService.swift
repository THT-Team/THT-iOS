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
    tokenStore: TokenStore = UserDefaultTokenStore.shared,
    tokenProvider: TokenProvider = DefaultTokenProvider()
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

  public func signUp(_ signUpRequest: SignUpReq) -> Single<Token> {
    tokenProvider.signUp(signUpRequest)
      .flatMap { [unowned self] token in
        self.tokenStore.saveToken(token: token)
        return .just(token)
      }
  }

  public func signUpSNS(_ request: UserSNSSignUpRequest) -> Single<Token> {
    tokenProvider.signUpSNS(request)
  }

  public func needAuth() -> Bool {
    return tokenStore.getToken() == nil
  }

  public func login(phoneNumber: String, deviceKey: String) -> Single<Token> {
    tokenProvider.login(phoneNumber: phoneNumber, deviceKey: deviceKey)
      .flatMap { [unowned self] token in
        self.tokenStore.saveToken(token: token)
        return .just(token)
      }
  }

  public func loginSNS(_ userSNSLoginRequest: UserSNSLoginRequest) -> Single<Token> {
    tokenProvider.loginSNS(userSNSLoginRequest)
      .flatMap { [unowned self] token in
        self.tokenStore.saveToken(token: token)
        return .just(token)
      }
  }

  public func getToken() -> Token? {
    tokenStore.getToken()
  }
}

public class SessionProvider {
  private static var session: Moya.Session?

  public static func create() -> Moya.Session {
    if let session { return session }

    let token = UserDefaultTokenStore.shared.getToken()?.toAuthOCredential() ?? OAuthCredential(accessToken: "", accessTokenExpiresIn: Date().timeIntervalSince1970, userUuid: "")
    let authenticator = OAuthAuthenticator()
    let interceptor = AuthenticationInterceptor(authenticator: authenticator, credential: token)
    let session = Session(interceptor: interceptor)
    self.session = session
    return session
  }
}
