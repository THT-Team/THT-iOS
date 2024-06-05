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

public final class AuthRepository: ProviderProtocol {

  public typealias Target = AuthTarget
  public var provider: MoyaProvider<Target>

  public init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((Target) -> Moya.Endpoint)?) {
    self.provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
  }

  public convenience init() {
    self.init(isStub: false, sampleStatusCode: 200, customEndpointClosure: nil)
  }
}

extension AuthRepository: AuthRepositoryInterface {
  public func checkUserExist(phoneNumber: String) -> RxSwift.Single<AuthInterface.UserSignUpInfoRes> {
    request(type: UserSignUpInfoRes.self, target: .checkExistence(phoneNumber: phoneNumber))
  }
  
  public func refresh(token: Token) -> Single<Token> {
    request(type: Token.self, target: .refresh(token))
  }
  
  public func certificate(phoneNumber: String) -> Single<Int> {
    Single.just(PhoneValidationResponse(phoneNumber: "01012345678", authNumber: 123456))
      .map { $0.authNumber }
    //    request(type: PhoneValidationResponse.self, target: .certificate(phoneNumber: phoneNumber))
  }

  public func login(phoneNumber: String, deviceKey: String) -> Single<AuthInterface.Token> {
    request(type: Token.self, target: .login(phoneNumber: phoneNumber, deviceKey: deviceKey))
  }

  public func loginSNS(_ userSNSLoginRequest: AuthInterface.UserSNSLoginRequest) -> Single<AuthInterface.Token> {
    request(type: Token.self, target: .loginSNS(request: userSNSLoginRequest))
  }
}

