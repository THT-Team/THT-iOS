//
//  SignUpRepository.swift
//  Data
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

import SignUpInterface
import AuthInterface
import Networks

import RxSwift
import RxMoya
import Moya

import Core

public final class SignUpRepository: ProviderProtocol {

  public typealias Target = SignUpTarget
  public var provider: MoyaProvider<Target>

  public init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((SignUpTarget) -> Moya.Endpoint)?) {
    self.provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
    TFLogger.dataLogger.log("SignUpRepository init")
  }

  public convenience init() {
    self.init(isStub: false, sampleStatusCode: 200, customEndpointClosure: nil)
  }
}

extension SignUpRepository: SignUpRepositoryInterface {
  public func uploadImage(data: [Data]) -> RxSwift.Single<[String]> {
    .just(["test.jpg", "test2.jpg"])
  }
  
  public func signUp(_ signUpRequest: SignUpInterface.SignUpReq) -> RxSwift.Single<AuthInterface.Token> {
    request(type: Token.self, target: .signUp(signUpReq: signUpRequest))
  }
  
  public func certificate(phoneNumber: String) -> RxSwift.Single<Int> {
    Single.just(PhoneValidationResponse(phoneNumber: "01012345678", authNumber: 123456))
      .map { $0.authNumber }

    //    request(type: PhoneValidationResponse.self, target: .certificate(phoneNumber: phoneNumber))
  }

  public func checkNickname(nickname: String) -> RxSwift.Single<Bool> {
    request(type: UserNicknameValidRes.self, target: .checkNickname(nickname: nickname))
      .map { $0.isDuplicate }
  }

  public func idealTypes() -> RxSwift.Single<[EmojiType]> {
    request(type: [EmojiType].self, target: .idealTypes)
  }

  public func interests() -> RxSwift.Single<[EmojiType]> {
    request(type: [EmojiType].self, target: .interests)
  }

  public func fetchAgreements() -> Single<Agreement> {
    request(type: Agreement.self, target: .agreement)
  }
}
