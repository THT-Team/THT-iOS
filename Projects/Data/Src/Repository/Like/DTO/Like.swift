//
//  HeartLikeResponse.swift
//  Falling
//
//  Created by Kanghos on 2023/09/11.
//

import Foundation

import Domain

extension Like {
  struct Res: Decodable {
    let dailyFallingIdx, likeIdx: Int
    let topic, issue, userUUID, username: String
    let profileURL: String
    let age: Int
    let address: String
    let receivedTime: Date

    enum CodingKeys: String, CodingKey {
      case dailyFallingIdx, likeIdx, topic, issue
      case userUUID = "userUuid"
      case username
      case profileURL = "profileUrl"
      case age, address, receivedTime
    }

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
}
