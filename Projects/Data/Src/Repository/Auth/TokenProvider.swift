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
import Domain

public enum AppEnvironment {
  case debug
  case release
}

public class BaseProvider<Target: TargetType>: ProviderProtocol {

  public var provider: MoyaProvider<Target>

  public init(_ environment: AppEnvironment) {
    switch environment {
    case .debug:
      self.provider = Self.makeStubProvider()
    case .release:
      self.provider = Self.makeProvider()
    }
  }
}

public typealias DefaultTokenProvider = BaseProvider<TokenProviderTarget>

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

  public func refresh(_ token: Token) async throws -> Token {
    try await request(target: .refresh(token))
  }
}
