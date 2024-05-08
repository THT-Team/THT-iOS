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
  public init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((Target) -> Moya.Endpoint)?) {
    self.provider = MyPageRepository.consProvider(isStub, sampleStatusCode, customEndpointClosure)
  }
}
//
//
//extension MyPageRepository: MyPageRepositoryInterface {
//  public func blockUserFriendContact(request: UserFriendContactReq) -> Single<UserFriendContactRes> {
//    req
//    request(type: UserFriendContactRes.self, target: . .blo(request: request))
//  }
//}
