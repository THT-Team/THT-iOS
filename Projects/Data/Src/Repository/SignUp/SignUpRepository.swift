//
//  SignUpRepository.swift
//  Data
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

import SignUpInterface
import Networks

import RxSwift
import RxMoya
import Moya

public final class SignUpRepository: ProviderProtocol {

  public typealias Target = SignUpTarget
  public var provider: MoyaProvider<Target>

  public init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((SignUpTarget) -> Moya.Endpoint)?) {
    self.provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
  }

  public convenience init() {
    self.init(isStub: false, sampleStatusCode: 200, customEndpointClosure: nil)
  }
}

extension SignUpRepository: SignUpRepositoryInterface {
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

  // TODO: Separate the logic of fetching contacts
  public func block(contacts: [ContactType]) -> Single<Int> {
    self.request(type: UserFriendContactRes.self, target: .block(contacts: .init(contacts: contacts)))
      .map { $0.count }
  }
}
