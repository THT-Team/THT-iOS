//
//  LikeDTO.swift
//  Data
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation
import LikeInterface

import Foundation

// MARK: - HeartDTO
struct HeartListRes: Codable {
    let likeList: [LikeRes]
    let size, lastFallingTopicIdx, lastLikeIdx: Int
}

extension HeartListRes {
  func toDomain() -> LikeListinfo {
    LikeListinfo(
      likeList: self.likeList.map { $0.toDomain() },
      size: self.size,
      lastFallingTopicIdx: self.lastFallingTopicIdx,
      lastLikeIdx: self.lastLikeIdx
    )
  }
}

// MARK: - LikeList
struct LikeRes: Codable {
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

  static var mock: LikeRes {
    LikeRes(dailyFallingIdx: 1, likeIdx: 1, topic: "등산하기", issue: "취미", userUUID: "1", username: "유저1", profileURL: "url", age: 20, address: "주소", receivedTime: "2023-09-05 17:15:52")
  }
}

extension LikeRes {
  func toDomain() -> Like {
    Like (
      dailyFallingIdx: self.dailyFallingIdx,
      likeIdx: self.likeIdx,
      topic: self.topic,
      issue: self.issue,
      userUUID: self.userUUID,
      username: self.username,
      profileURL: self.profileURL,
      age: self.age,
      address: self.address,
      receivedTime: self.receivedTime
    )
  }
}
