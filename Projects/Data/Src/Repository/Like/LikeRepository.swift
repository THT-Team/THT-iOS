//
//  LikeRepository.swift
//  Data
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation

import LikeInterface
import Domain

import RxSwift
import RxMoya
import Moya

import Networks

public final class LikeRepository: ProviderProtocol {
  public typealias Target = LikeTarget
  public var provider: MoyaProvider<Target>

  public init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((Target) -> Moya.Endpoint)?) {
    self.provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
  }
}

extension LikeRepository: LikeRepositoryInterface {

  public func fetchList(size: Int, lastTopicIndex: Int?, lastLikeIndex: Int?) -> Single<LikeListinfo> {
    request(type: LikeListinfo.Res.self, target: .list(
        request: HeartListReq(
          size: size,
          lastFallingTopicIdx: lastTopicIndex,
          lastLikeIdx: lastLikeIndex)))
    .map { $0.toDomain() }
  }

  public func user(id: String) -> Single<UserInfo> {
    request(type: UserInfo.Res.self, target: .userInfo(id: id))
      .map { $0.toDomain() }
  }

  public func reject(index: Int) -> Single<Void> {
    requestWithNoContent(target: .reject(request: .init(likeIdx: index)))
  }

  public func like(id: String, topicID: String) -> Single<LikeMatching> {
    request(type: LikeMatching.Res.self, target: .like(id: id, topic: topicID))
      .map { $0.toDomain() }
  }

  public func dontLike(id: String, topicID: String) -> Single<Void> {
    requestWithNoContent(target: .dontLike(id: id, topic: topicID))
  }
}
