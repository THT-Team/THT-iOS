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

import Core

public final class AuthRepository: ProviderProtocol {

  public typealias Target = AuthTarget
  public var provider: MoyaProvider<Target>
  private let authService: AuthServiceType

  public init(authService: AuthServiceType) {
    self.authService = authService

    self.provider = Self.makeProvider(session: authService.createSession())
    TFLogger.dataLogger.debug("init AuthRepo")
  }

  deinit {
    TFLogger.cycle(name: self)
  }
}

extension AuthRepository: AuthRepositoryInterface {
  public func checkUserExist(phoneNumber: String) -> RxSwift.Single<AuthInterface.UserSignUpInfoRes> {
    request(type: UserSignUpInfoRes.self, target: .checkExistence(phoneNumber: phoneNumber))
  }
  
  public func refresh(completion: @escaping (Result<Token, Error>) -> Void) {
    authService.refreshToken(completion: completion)
  }

  public func refresh() -> Single<Token> {
    authService.refresh()
  }

  public func certificate(phoneNumber: String) -> Single<Int> {
    Single.just(PhoneValidationResponse(phoneNumber: "01012345678", authNumber: 123456))
      .map { $0.authNumber }
    //    request(type: PhoneValidationResponse.self, target: .certificate(phoneNumber: phoneNumber))
  }

  public func login(phoneNumber: String, deviceKey: String) -> Single<AuthInterface.Token> {
    authService.login(phoneNumber: phoneNumber, deviceKey: deviceKey)
  }

  public func loginSNS(_ userSNSLoginRequest: AuthInterface.UserSNSLoginRequest) -> Single<AuthInterface.Token> {
    authService.loginSNS(userSNSLoginRequest)
  }
}

