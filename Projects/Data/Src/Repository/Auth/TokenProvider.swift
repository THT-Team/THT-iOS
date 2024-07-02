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

public final class DefaultTokenProvider: ProviderProtocol {
  public typealias Target = TokenProviderTarget

  public var provider: MoyaProvider<Target>

  public init() {
    provider = Self.makeProvider()
  }
}

extension DefaultTokenProvider: TokenProvider {
  public func signUp(_ signUpRequest: SignUpReq) -> Single<Token> {
    request(type: Token.self, target: .signUp(signUpRequest))
  }
  
  public func refresh(token: AuthInterface.Token) -> RxSwift.Single<AuthInterface.Token> {
    request(type: Token.self, target: .refresh(token))
  }
  
  public func refreshToken(token: Token, completion: @escaping (Result<Token, Error>) -> Void) {
    request(target: .refresh(token), completion: completion)
  }

  public func login(phoneNumber: String, deviceKey: String) -> Single<Token> {
    request(type: Token.self, target: .login(phoneNumber: phoneNumber, deviceKey: deviceKey))
  }

  public func loginSNS(_ userSNSLoginRequest: UserSNSLoginRequest) -> Single<Token> {
    request(type: Token.self, target: .loginSNS(request: userSNSLoginRequest))
  }
}
