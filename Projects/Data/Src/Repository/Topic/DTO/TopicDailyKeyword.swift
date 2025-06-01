//
//  TopicDailyKeyword.swift
//  Data
//
//  Created by Kanghos on 1/6/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation
import Domain

extension TopicDailyKeyword {
  struct Res: Decodable {
    let expirationUnixTime: Date // unixTime  1687744800,
    let type: String //  "oneChoice",
    let introduction: String
    let fallingTopicList: [DailyKeyword.Res]
    
    private enum CodingKeys: String, CodingKey {
      case expirationUnixTime
      case type
      case introduction
      case fallingTopicList
    }
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      
      let timestamp = try container.decode(Int.self, forKey: .expirationUnixTime)
      self.expirationUnixTime = Date(timeIntervalSince1970: TimeInterval(timestamp))
      
      self.type = try container.decode(String.self, forKey: .type)
      
      self.introduction = try container.decode(String.self, forKey: .introduction)
      
      self.fallingTopicList = try container.decode([DailyKeyword.Res].self, forKey: .fallingTopicList)
    }

    func toDomain() -> TopicDailyKeyword {
      return TopicDailyKeyword(expirationUnixTime: expirationUnixTime, type: type, introduction: introduction, fallingTopicList: fallingTopicList.map { $0.toDomain() })
    }
  }
}
