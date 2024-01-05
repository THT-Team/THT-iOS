//
//  LikeRepository.swift
//  Data
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation

import LikeInterface

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

  public func fetchList(size: Int, lastTopicIndex: Int?, lastLikeIndex: Int?) -> Observable<LikeListinfo> {
    
    request(
      type: HeartListRes.self,
      target: .list(
        request: HeartListReq(
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
    request(type: HeartUserRes.self, target: .userInfo(id: id))
      .map { $0.toDomain() }
      .asObservable()
  }
}
