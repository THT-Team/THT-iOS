//
//  HeartAPI.swift
//  Falling
//
//  Created by Kanghos on 2023/09/11.
//

import Foundation

import RxSwift
import RxMoya
import Moya

final class HeartAPI: ProviderProtocol {

  typealias Target = HeartTarget
  var provider: MoyaProvider<Target>

  init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((HeartTarget) -> Moya.Endpoint)?) {
    self.provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
  }

  func like(id: String, topicIndex: Int) -> Single<HeartLikeResponse> {
    request(type: HeartLikeResponse.self, target: .like(id: id, topic: topicIndex))
  }

  func reject(index: Int) -> Single<Void> {
    requestWithNoContent(target: .reject(request: .init(likeIdx: index)))
  }
  func list(pagingRequest: HeartListRequest) -> Single<HeartListResponse> {
    request(type: HeartListResponse.self, target: .list(request: pagingRequest))
  }
}