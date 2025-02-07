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

    func toDomain() -> TopicDailyKeyword {
      return TopicDailyKeyword(expirationUnixTime: expirationUnixTime, type: type, introduction: introduction, fallingTopicList: fallingTopicList.map { $0.toDomain() })
    }
  }
}
