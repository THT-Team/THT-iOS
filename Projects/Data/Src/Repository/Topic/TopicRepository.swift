//
//  TopicRepository.swift
//  Data
//
//  Created by Kanghos on 1/6/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation

import Domain
import Networks

import RxSwift
import RxMoya
import Moya

public final class TopicRepository: ProviderProtocol {
  public typealias Target = TopicTarget
  public var provider: MoyaProvider<Target>

  public init() {
    provider = Self.makeProvider()
  }
}

extension TopicRepository: TopicRepositoryInterface {
  public func checkChooseTopic() -> RxSwift.Single<Bool> {
    request(type: TopicChoose.self, target: .checkDailyTopic)
      .map { $0.isChoose }
  }
  
  public func dailyKeyword() -> RxSwift.Single<[Domain.TopicDailyKeyword]> {
    request(type: [TopicDailyKeyword.Res].self, target: .dailyKeyword)
      .map { $0.map { $0.toDomain() } }
  }
  
  public func choice(_ fallingIndex: String) -> RxSwift.Single<Void> {
    requestWithNoContent(target: .choice(fallingIndex))
  }
  
  public func talkKeyword() -> Single<[TopicKeyword]> {
    request(type: [TopicKeyword.Res].self, target: .talkKeyword)
      .map { $0.map { $0.toDomain() } }
  }
}
