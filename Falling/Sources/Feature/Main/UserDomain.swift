//
//  UserSection.swift
//  Falling
//
//  Created by SeungMin on 2023/10/06.
//
import Foundation

enum MainProfileSection {
  case profile
}

struct UserDomain: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
  static func == (lhs: UserDomain, rhs: UserDomain) -> Bool {
    lhs.identifier == rhs.identifier
  }

  let identifier = UUID()
  let username: String
  let userUUID: String
  let age: Int
  let address: String
  let idealTypes, interests: [EmojiType]
  let userProfilePhotos: [UserProfilePhoto]
  let introduction: String
}

extension UserInfo {
  func toDomain() -> UserDomain {
    UserDomain(username: self.username, userUUID: self.userUUID, age: self.age, address: self.address, idealTypes: self.idealTypeResponseList.map { $0.toDomain() }, interests: self.interestResponses.map { $0.toDomain() }, userProfilePhotos: self.userProfilePhotos, introduction: self.introduction)
  }
}
