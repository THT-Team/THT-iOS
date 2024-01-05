//
//  HeartUserResponse.swift
//  Falling
//
//  Created by Kanghos on 2023/09/17.
//

import Foundation

import LikeInterface

// MARK: - UserResponse
struct HeartUserRes: Codable {
    let username, userUUID: String
    let age: Int
    let introduction, address, phoneNumber, email: String
    let idealTypeList, interestsList: [IdealTypeResponseList]
    let userProfilePhotos: [UserProfilePhoto]

    enum CodingKeys: String, CodingKey {
        case username
        case userUUID = "userUuid"
        case age, introduction, address, phoneNumber, email, idealTypeList, interestsList, userProfilePhotos
    }

  var description: String {
    username + ", " + "\(age)"
  }
}

// MARK: - List
struct EmojiType {
  let identifier = UUID()
    let idx: Int
    let name, emojiCode: String
}

extension HeartUserRes {
  func toDomain() -> LikeUserInfo {
    LikeUserInfo(
      username: self.username,
      userUUID: self.userUUID,
      age: self.age,
      introduction: self.introduction,
      address: self.address,
      phoneNumber: self.phoneNumber,
      email: self.email,
      idealTypeList: self.idealTypeList,
      interestsList: self.interestsList,
      userProfilePhotos: self.userProfilePhotos
    )
  }
}

