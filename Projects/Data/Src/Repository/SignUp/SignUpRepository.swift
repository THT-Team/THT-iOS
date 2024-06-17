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

public final class SignUpRepository: ProviderProtocol {

  public typealias Target = SignUpTarget
  public var provider: MoyaProvider<Target>
  private let authService: AuthServiceType

  public init(authService: AuthServiceType) {
    self.authService = authService
    self.provider = Self.makeProvider(session: authService.createSession())
  }
}

extension SignUpRepository: SignUpRepositoryInterface {
  public func uploadImage(data: [Data]) -> RxSwift.Single<[String]> {
    .just(["test.jpg", "test2.jpg"])
  }
  
  public func signUp(_ signUpRequest: SignUpReq) -> Single<Void> {
    authService.signUp(signUpRequest)
      .map { _ in }
  }
  
  public func certificate(phoneNumber: String) -> Single<Int> {
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
