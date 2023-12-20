//
//  HeartAPI.swift
//  Falling
//
//  Created by Kanghos on 2023/09/11.
//

import Foundation

import LikeInterface
import Networks

import RxSwift
import RxMoya
import Moya


public protocol LikeService {
  func fetchList(size: Int, lastTopicIndex: Int?, lastLikeIndex: Int?) -> Observable<LikeListinfo>
  func user(id: String) -> Observable<LikeUserInfo>
}

public final class NetworkLikeService: ProviderProtocol {
  public typealias Target = HeartTarget

  public var provider: MoyaProvider<Target>

  public init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((HeartTarget) -> Moya.Endpoint)?) {
    self.provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
  }
}

extension NetworkLikeService: LikeService {
  public func fetchList(size: Int, lastTopicIndex: Int?, lastLikeIndex: Int?) -> Observable<LikeListinfo> {
    request(
      type: HeartListResponse.self,
      target: .list(
        request: HeartListRequest(
          size: size,
          lastFallingTopicIdx: lastTopicIndex,
          lastLikeIdx: lastLikeIndex
          )
      )
    )
    .map { $0.toDomain() }
    .asObservable()
  }

  public func user(id: String) -> Observable<LikeUserInfo> {
    request(type: HeartUserResponse.self, target: .userInfo(id: id))
      .map { $0.toDomain() }
      .asObservable()
  }
}
