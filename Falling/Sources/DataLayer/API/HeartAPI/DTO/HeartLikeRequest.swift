//
//  HeartLikeRequest.swift
//  Falling
//
//  Created by Kanghos on 2023/09/11.
//

import Foundation

struct HeartLikeRequest: Codable {
  let favoriteUserUUID: String
  let dailyTopicIndex: String

  enum CodingKeys: String, CodingKey {
      case favoriteUserUUID = "favorite-user-uuid"
      case dailyTopicIndex = "daily-topic-idx"
  }
}
