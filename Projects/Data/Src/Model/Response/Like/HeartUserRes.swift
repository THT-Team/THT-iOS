//
//  HeartUserResponse.swift
//  Falling
//
//  Created by Kanghos on 2023/09/17.
//

import Foundation

import LikeInterface
import Domain

// MARK: - UserResponse
struct HeartUserRes: Codable {
    let username, userUUID: String
    let age: Int
    let introduction, address, phoneNumber, email: String
    let idealTypeList, interestsList: [IdealTypeResponseList]
    let userProfilePhotos: [UserProfilePhotoRes]

    enum CodingKeys: String, CodingKey {
        case username
        case userUUID = "userUuid"
        case age, introduction, address, phoneNumber, email, idealTypeList, interestsList, userProfilePhotos
    }

  var description: String {
    username + ", " + "\(age)"
  }
}

extension HeartUserRes {
  func toDomain() -> UserInfo {
    UserInfo(
      username: self.username,
      userUUID: self.userUUID,
      age: self.age,
      introduction: self.introduction,
      address: self.address,
      phoneNumber: self.phoneNumber,
      email: self.email,
      idealTypeList: self.idealTypeList.map { $0.toDomain() },
      interestsList: self.interestsList.map { $0.toDomain() },
      userProfilePhotos: self.userProfilePhotos.map { $0.toDomain() }
    )
  }
}

