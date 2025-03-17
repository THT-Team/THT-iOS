//
//  UserInfoRes.swift
//  Data
//
//  Created by Kanghos on 2024/01/16.
//

import Foundation

import Domain

// MARK: - UserResponse
extension UserInfo {
  struct Res: Decodable {
    let username, userUUID: String
    let age: Int
    let introduction, address, phoneNumber, email: String
    let idealTypeList, interestsList: [IdealTypeResponseList]
    let userProfilePhotos: [UserProfilePhoto.Res]

    enum CodingKeys: String, CodingKey {
      case username
      case userUUID = "userUuid"
      case age, introduction, address, phoneNumber, email, idealTypeList, interestsList, userProfilePhotos
    }

    var description: String {
      username + ", " + "\(age)"
    }

    func toDomain() -> UserInfo {
      UserInfo(
        username: username, userUUID: userUUID, age: age, introduction: introduction,
        address: address, phoneNumber: phoneNumber, email: email,
        idealTypeList: idealTypeList.map { $0.toDomain() },
        interestsList: interestsList.map { $0.toDomain() },
        userProfilePhotos: userProfilePhotos.map { $0.toDomain() }
      )
    }
  }
}
