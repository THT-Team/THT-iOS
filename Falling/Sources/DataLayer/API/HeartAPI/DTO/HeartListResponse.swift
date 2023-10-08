//
//  HeartListResponse.swift
//  Falling
//
//  Created by Kanghos on 2023/09/11.
//

import Foundation

// MARK: - HeartDTO
struct HeartListResponse: Codable {
    let likeList: [LikeDTO]
    let size, lastFallingTopicIdx, lastLikeIdx: Int
}

// MARK: - LikeList
struct LikeDTO: Codable {
    let dailyFallingIdx, likeIdx: Int
    let topic, issue, userUUID, username: String
    let profileURL: String
    let age: Int
    let address, receivedTime: String

    enum CodingKeys: String, CodingKey {
        case dailyFallingIdx, likeIdx, topic, issue
        case userUUID = "userUuid"
        case username
        case profileURL = "profileUrl"
        case age, address, receivedTime
    }

  static var mock: LikeDTO {
    LikeDTO(dailyFallingIdx: 1, likeIdx: 1, topic: "등산하기", issue: "취미", userUUID: "1", username: "유저1", profileURL: "url", age: 20, address: "주소", receivedTime: "2023-09-05 17:15:52")
  }
}

struct HeartSectionMapper {
  static func map(list: [LikeDTO]) -> [LikeSection] {
    var mutableSection: [LikeSection] = []
    var topics: [String: [LikeDTO]] = [:]
    list.forEach { item in
      var topicSection = topics[item.topic] ?? []
      topicSection.append(item)
      topics.updateValue(topicSection, forKey: item.topic)
    }
    mutableSection = topics.map { pair in
      LikeSection(header: pair.key, items: pair.value)
    }
    return mutableSection
  }
}
