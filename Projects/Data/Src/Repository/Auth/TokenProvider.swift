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

public typealias DefaultTokenProvider = BaseRepository<TokenProviderTarget>

extension DefaultTokenProvider: TokenProvider {
  public func signUpSNS(_ signUpRequest: SNSUserInfo.SignUpRequest) -> RxSwift.Single<Token> {
    request(type: Token.self, target:  .signUpSNS(signUpRequest))
  }
  
  public func signUp(_ signUpRequest: SignUpReq) -> Single<Token> {
    request(type: Token.self, target: .signUp(signUpRequest))
  }

  public func login(phoneNumber: String, deviceKey: String) -> Single<Token> {
    request(type: Token.self, target: .login(phoneNumber: phoneNumber, deviceKey: deviceKey))
  }

  public func loginSNS(_ signUpRequest: SNSUserInfo.LoginRequest) -> Single<Token> {
    request(type: Token.self, target: .loginSNS(request: signUpRequest))
  }

  public func updateDeviceToken(_ token: String) -> Single<Void> {
    return requestWithNoContent(target: .updateDeviceToken(deviceKey: token))
  }
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
    do {
      let refreshToken: Token = try await request(target: .refresh(token))
      tokenStore.saveToken(token: refreshToken)
      return refreshToken
    } catch {
      throw AuthError.tokenRefreshFailed
    }
  }
}
