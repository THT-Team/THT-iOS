//
//  UserSection.swift
//  Falling
//
//  Created by SeungMin on 2023/10/06.
//
import Foundation

import RxDataSources

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
extension UserDTO {
//  func toDomain() -> UserDomain {
//    UserDomain(userIdx: self.userIdx)
//  }
}

struct UserSection {
  var header: String
  var items: [Item]
}

extension UserSection: AnimatableSectionModelType {
  typealias Item = UserDTO
  var identity: String {
    return self.header
  }
  
  init(original: UserSection, items: [Item]) {
    self = original
    self.items = items
  }
}

extension UserDTO: IdentifiableType, Equatable {
  static func == (lhs: UserDTO, rhs: UserDTO) -> Bool {
    lhs.identity == rhs.identity
  }

  var identity: Int {
    return userIdx
  }
}
