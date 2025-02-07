//
//  TopicDailyKeyword2.swift
//  Domain
//
//  Created by Kanghos on 1/6/25.
//

import Foundation

public struct TopicDailyKeyword {
  public let expirationUnixTime: Date // unixTime  1687744800,
  public let type: TopicType //  "oneChoice",
  public let introduction: String
  public let fallingTopicList: [DailyKeyword]

  public init(expirationUnixTime: Date, type: String, introduction: String, fallingTopicList: [DailyKeyword]) {
    self.expirationUnixTime = expirationUnixTime
    self.type = TopicType(rawValue: type) ?? .oneChoice
    self.introduction = introduction
    self.fallingTopicList = fallingTopicList
  }
}

