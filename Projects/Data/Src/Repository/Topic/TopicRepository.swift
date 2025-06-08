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

  public init(_ environment: RepositoryEnvironment) {
    switch environment {
    case .debug:
      self.provider = Self.makeStubProvider()
    case .release(let session):
      self.provider = Self.makeProvider(session: session)
    }
  }
}

extension TopicRepository: TopicRepositoryInterface {
  public func getCheckIsChooseDailyTopic() -> RxSwift.Single<Bool> {
    request(type: TopicChoose.self, target: .checkDailyTopic)
      .map { $0.isChoose }
  }
  
  public func getDailyKeyword() -> RxSwift.Single<Domain.TopicDailyKeyword> {
    request(type: TopicDailyKeyword.Res.self, target: .dailyKeyword)
      .map { $0.toDomain() }
  }
  
  public func postChoiceTopic(_ fallingIndex: String) -> RxSwift.Single<Void> {
    requestWithNoContent(target: .choice(fallingIndex))
  }
  
  public func getTalkKeywords() -> Single<[TopicKeyword]> {
    request(type: [TopicKeyword.Res].self, target: .talkKeyword)
      .map { $0.map { $0.toDomain() } }
  }
}
