//
//  DailyFallingUserResponse.swift
//  Falling
//
//  Created by Kanghos on 2023/10/09.
//

import Foundation

// MARK: - DailyFallingUserResponse
struct DailyFallingUserResponse: Codable {
    let selectDailyFallingIdx, topicExpirationUnixTime: Int
    let userInfos: [UserInfo]
}

// MARK: - UserInfo
struct UserInfo: Codable {
    let username, userUUID: String
    let age: Int
    let address: String
    let isBirthDay: Bool
    let idealTypeResponseList, interestResponses: [IdealTypeResponseList]
    let userProfilePhotos: [UserProfilePhoto]
    let introduction: String
    let userDailyFallingCourserIdx: Int

    enum CodingKeys: String, CodingKey {
        case username
        case userUUID = "userUuid"
        case age, address, isBirthDay, idealTypeResponseList, interestResponses, userProfilePhotos, introduction, userDailyFallingCourserIdx
    }
}

// MARK: - IdealTypeResponseList
struct IdealTypeResponseList: Codable {
    let idx: Int
    let name, emojiCode: String
}

extension IdealTypeResponseList {
  func toDomain() -> EmojiType {
    EmojiType(idx: self.idx, name: self.name, emojiCode: self.emojiCode)
  }
}
