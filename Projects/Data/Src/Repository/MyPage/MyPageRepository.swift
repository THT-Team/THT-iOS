//
//  MyPageRepository.swift
//  Data
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import MyPageInterface
import SignUpInterface

import Networks

import RxSwift
import RxMoya
import Moya

public final class MyPageRepository: ProviderProtocol {
  public typealias Target = MyPageTarget
  public var provider: MoyaProvider<Target>

  public init() {
    self.provider = Self.makeStubProvider()
  }
  public init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((Target) -> Moya.Endpoint)?) {
    self.provider = MyPageRepository.consProvider(isStub, sampleStatusCode, customEndpointClosure)
  }
}


extension MyPageRepository: MyPageRepositoryInterface {
  public func fetchUserContacts() -> RxSwift.Single<Int> {
    .just(1)
  }
  
  public func updateUserContacts(contacts: [SignUpInterface.ContactType]) -> RxSwift.Single<Int> {
    request(type: UserFriendContactRes.self, target: .updateUserContacts(contacts))
      .map { $0.count }
  }

  public func fetchUser() -> Single<User> {
    request(type: UserDetailRes.self, target: .user)
      .map { $0.toDomain() }
  }

  public func updateAlarmSetting(_ settings: [String: Bool]) -> Completable {
    requestWithNoContent(target: .updateAlarmSetting(settings))
  }
}
