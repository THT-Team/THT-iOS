//
//  TokenProvider.swift
//  Data
//
//  Created by Kanghos on 6/5/24.
//

import Foundation

import RxMoya
import Moya
import RxSwift

import Networks

import AuthInterface
import Domain

public final class DefaultTokenProvider: ProviderProtocol {
  public typealias Target = TokenProviderTarget

  public var provider: MoyaProvider<Target>

  public init() {
    provider = Self.makeProvider(session: SessionProvider.create())
  }
}

extension DefaultTokenProvider: TokenProvider {
  public func signUpSNS(_ userSNSSignUpRequest: UserSNSSignUpRequest) -> RxSwift.Single<Token> {
    request(type: Token.self, target: .signUpSNS(userSNSSignUpRequest))
  }
  
  public func signUp(_ signUpRequest: SignUpReq) -> Single<Token> {
    request(type: Token.self, target: .signUp(signUpRequest))
  }

  public func login(phoneNumber: String, deviceKey: String) -> Single<Token> {
    request(type: Token.self, target: .login(phoneNumber: phoneNumber, deviceKey: deviceKey))
  }

  public func loginSNS(_ userSNSLoginRequest: UserSNSLoginRequest) -> Single<Token> {
    request(type: Token.self, target: .loginSNS(request: userSNSLoginRequest))
  }
}

public protocol TokenRefresher {
  func refresh(_ token: Token) async throws -> Token
}

public final class DefaultTokenRefresher: ProviderProtocol, TokenRefresher {
  
  public typealias Target = TokenProviderTarget

  public var provider: MoyaProvider<Target>
  private let tokenStore: TokenStore

  public init(tokenStore: TokenStore = UserDefaultTokenStore.shared) {
    provider = Self.makeProvider()
    self.tokenStore = tokenStore
  }

  public func refresh(_ token: Token) async throws -> Token {
    let refreshToken: Token = try await request(target: .refresh(token))
    tokenStore.saveToken(token: refreshToken)
    return refreshToken
  }
}
