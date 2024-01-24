//
//  FallingUserRes.swift
//  Data
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

import Domain

import FallingInterface

// MARK: - FallingUserRes
struct FallingUserRes: Decodable {
  let selectDailyFallingIdx, topicExpirationUnixTime: Int
  let userInfos: [UserRes]
}

// MARK: - UserRes
struct UserRes: Decodable {
  let username, userUUID: String
  let age: Int
  let address: String
  let isBirthDay: Bool
  let idealTypeResponseList, interestResponses: [IdealTypeResponseList]
  let userProfilePhotos: [UserProfilePhotoRes]
  let introduction: String
  let userDailyFallingCourserIdx: Int

  enum CodingKeys: String, CodingKey {
      case username
      case userUUID = "userUuid"
      case age, address, isBirthDay, idealTypeResponseList, interestResponses, userProfilePhotos, introduction, userDailyFallingCourserIdx
  }
}

extension UserRes {
  func toDomain() -> FallingUser {
    FallingUser(
      username: self.username,
      userUUID: self.userUUID,
      age: self.age,
      address: self.address,
      isBirthDay: self.isBirthDay,
      idealTypeResponseList: self.idealTypeResponseList.map { $0.toDomain() },
      interestResponses: self.interestResponses.map { $0.toDomain() },
      userProfilePhotos: self.userProfilePhotos.map { $0.toDomain() },
      introduction: self.introduction,
      userDailyFallingCourserIdx: self.userDailyFallingCourserIdx)
  }
}

extension FallingUserRes {
  func toDomain() -> FallingUserInfo {
    FallingUserInfo(
      selectDailyFallingIdx: self.selectDailyFallingIdx,
      topicExpirationUnixTime: self.topicExpirationUnixTime,
      userInfos: self.userInfos.map { $0.toDomain() }
    )
  }
}
