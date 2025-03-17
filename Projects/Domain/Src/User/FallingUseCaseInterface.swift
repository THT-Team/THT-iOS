//
//  FallingUseCaseInterface.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

import RxSwift

public protocol FallingUseCaseInterface {
  func user(alreadySeenUserUUIDList: [String], userDailyFallingCourserIdx: Int, size: Int) -> Single<FallingUserInfo>
  func block(userUUID: String) -> Single<String>
  func report(userUUID: String, reason: String) -> Single<String>
  func like(userUUID: String, topicIndex: String) -> Single<MatchResponse>
  func reject(userUUID: String, topicIndex: String) -> Single<Void>
}


public struct MatchResponse {
  public let isMatched: Bool
  public let chatIndex: String

  public init(isMatched: Bool, chatIndex: String) {
    self.isMatched = isMatched
    self.chatIndex = chatIndex
  }
}
