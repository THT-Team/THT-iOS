//
//  FallingUserRes.swift
//  Data
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

import Domain

extension FallingUser {
  struct Res: Decodable {
    let username: String
    let userUUID: String
    let age: Int
    let address: String
    let isBirthDay: Bool
    let idealTypeResponseList: [IdealTypeResponseList]
    let interestResponses: [IdealTypeResponseList]
    let userProfilePhotos: [UserProfilePhoto.Res]
    let introduction: String
    let userDailyFallingCourserIdx: Int
    let distance: Int

    enum CodingKeys: String, CodingKey {
      case username
      case userUUID = "userUuid"
      case age, address, isBirthDay
      case idealTypeResponseList = "idealTypeList"
      case interestResponses = "interestList"
      case userProfilePhotos, introduction, userDailyFallingCourserIdx, distance
    }
    
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
        userDailyFallingCourserIdx: self.userDailyFallingCourserIdx,
        distance: self.distance
      )
    }
  }
}
