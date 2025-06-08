//
//  TopicDailyKeyword2.swift
//  Domain
//
//  Created by Kanghos on 1/6/25.
//

import Foundation

public struct TopicDailyKeyword: Equatable, Hashable {
  public let id = UUID().uuidString
  public let expirationUnixTime: Date
  public let type: TopicType
  public let introduction: String
  public let fallingTopicList: [DailyKeyword]
  
  public init(expirationUnixTime: Date, type: String, introduction: String, fallingTopicList: [DailyKeyword]) {
    self.expirationUnixTime = expirationUnixTime
    self.type = TopicType(rawValue: type) ?? .oneChoice
    self.introduction = introduction
    self.fallingTopicList = fallingTopicList
  }
}
