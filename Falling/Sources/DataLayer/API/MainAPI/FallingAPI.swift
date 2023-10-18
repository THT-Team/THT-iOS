//
//  FallingAPI.swift
//  Falling
//
//  Created by Kanghos on 2023/10/09.
//

import Foundation

import RxSwift
import RxMoya
import Moya

protocol FallingAPIType: ProviderProtocol where Target == FallingTarget {
  func user(_ requestInfo: DailyFallingUserRequest) -> Single<DailyFallingUserResponse>
}

final class FallingAPI: FallingAPIType {

  var provider: MoyaProvider<Target>
  init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((Target) -> Moya.Endpoint)?) {
    self.provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
  }

  func user(_ requestInfo: DailyFallingUserRequest) -> Single<DailyFallingUserResponse> {
    request(type: DailyFallingUserResponse.self, target: .users(requestInfo))
  }
}
