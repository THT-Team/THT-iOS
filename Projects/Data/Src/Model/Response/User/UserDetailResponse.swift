//
//  UserDetailResponse.swift
//  Data
//
//  Created by Kanghos on 6/6/24.
//

import Foundation
import MyPageInterface
import SignUpInterface

// MARK: - UserDetailRes
struct UserDetailRes: Codable {
  let preferGender, username, userUUID: String
  let age: Int
  let introduction, address, phoneNumber, email: String
  let gender: String
  let tall: Int
  let smoking, drinking, religion: String
  let idealTypeList, interestsList: [SignUpInterface.EmojiType]
  let userProfilePhotos: [UserProfilePhotoRes]
  let userAgreements: [String: Bool]

  enum CodingKeys: String, CodingKey {
    case preferGender = "prefer_gender"
    case username
    case userUUID = "userUuid"
    case age, introduction, address, phoneNumber, email, gender, tall, smoking, drinking, religion, idealTypeList, interestsList, userProfilePhotos, userAgreements
  }
}

extension UserDetailRes {
  func toDomain() -> User {

    User(
      preferGender: Gender(rawValue: self.preferGender)!,
      username: self.username,
      userUUID: self.userUUID,
      age: self.age,
      introduction: self.introduction,
      address: self.address,
      phoneNumber: self.phoneNumber,
      email: self.email,
      gender: Gender(rawValue: self.gender)!,
      tall: self.tall,
      smoking: Frequency(rawValue: self.smoking)!,
      drinking: Frequency(rawValue: self.drinking)!,
      religion: Religion(rawValue: self.religion)!,
      idealTypeList: self.idealTypeList,
      interestsList: self.interestsList,
      userProfilePhotos: self.userProfilePhotos.map { $0.toDomain() },
      userAgreements: self.userAgreements)
  }
}
