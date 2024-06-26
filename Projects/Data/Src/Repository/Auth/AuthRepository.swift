//
//  AuthRepository.swift
//  Data
//
//  Created by Kanghos on 6/3/24.
//

import Foundation

import AuthInterface
import SignUpInterface
import Networks

import RxSwift
import RxMoya
import Moya
import Alamofire
import Core

public final class AuthRepository: ProviderProtocol {

  public typealias Target = AuthTarget
  public var provider: MoyaProvider<Target>
  private let tokenStore: TokenStore
  private let tokenProvider: TokenProvider

  public init(tokenStore: TokenStore, tokenProvider: TokenProvider) {
    self.tokenStore = tokenStore
    self.tokenProvider = tokenProvider

    let token = (try? tokenStore.getToken()) ?? Token(accessToken: "", accessTokenExpiresIn: 0)
    let credential = token.toAuthOCredential()

    let authenticator = OAuthAuthenticator(tokenProvider: tokenProvider)
    let intercepter = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
    let session = Session(interceptor: intercepter)

    self.provider = Self.makeProvider()
    TFLogger.dataLogger.log("AuthRepository init")
  }
}

extension AuthRepository: AuthRepositoryInterface {
  public func checkUserExist(phoneNumber: String) -> RxSwift.Single<AuthInterface.UserSignUpInfoRes> {
    request(type: UserSignUpInfoRes.self, target: .checkExistence(phoneNumber: phoneNumber))
  }
  
  public func refresh(_ token: Token, completion: @escaping (Result<Token, Error>) -> Void) {
    tokenProvider.refreshToken(token: token, completion: completion)
  }

  public func refresh(_ token: Token) -> Single<Token> {
    tokenProvider.refresh(token: token)
  }

  public func certificate(phoneNumber: String) -> Single<Int> {
    Single.just(PhoneValidationResponse(phoneNumber: "01012345678", authNumber: 123456))
      .map { $0.authNumber }
    //    request(type: PhoneValidationResponse.self, target: .certificate(phoneNumber: phoneNumber))
  }

  public func login(phoneNumber: String, deviceKey: String) -> Single<AuthInterface.Token> {
    tokenProvider.login(phoneNumber: phoneNumber, deviceKey: deviceKey)
  }

  public func loginSNS(_ userSNSLoginRequest: AuthInterface.UserSNSLoginRequest) -> Single<AuthInterface.Token> {
    tokenProvider.loginSNS(userSNSLoginRequest)
  }
}

