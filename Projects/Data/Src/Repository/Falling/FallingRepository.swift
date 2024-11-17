//
//  FallingRepository.swift
//  Data
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

import FallingInterface
import Networks

import RxSwift
import Moya

public final class FallingRepository: ProviderProtocol {
  public typealias Target = FallingTarget
  public var provider: MoyaProvider<Target>
//  public init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((Target) -> Moya.Endpoint)?) {
//    self.provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
//  }
  
  public init(session: Session) {
    self.provider = Self.makeProvider(session: session)
  }
}


extension FallingRepository: FallingRepositoryInterface {
  public func user(alreadySeenUserUUIDList: [String], userDailyFallingCourserIdx: Int, size: Int) -> Single<FallingUserInfo> {
    request(
      type: FallingUserRes.self,
      target: .users(
        FallingUserReq(
        alreadySeenUserUUIDList: alreadySeenUserUUIDList,
        userDailyFallingCourserIdx: userDailyFallingCourserIdx,
        size: size
        )
      )
    )
    .map { $0.toDomain() }
  }
}
