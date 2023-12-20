//
//  LikeUserInfo.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation

// MARK: - UserResponse
public struct LikeUserInfo: Codable {
  public let username, userUUID: String
  public let age: Int
  public let introduction, address, phoneNumber, email: String
  public let idealTypeList, interestsList: [IdealTypeResponseList]
  public let userProfilePhotos: [UserProfilePhoto]

  enum CodingKeys: String, CodingKey {
    case username
    case userUUID = "userUuid"
    case age, introduction, address, phoneNumber, email, idealTypeList, interestsList, userProfilePhotos
  }

  public var description: String {
    username + ", " + "\(age)"
  }

  public init(username: String, userUUID: String, age: Int, introduction: String, address: String, phoneNumber: String, email: String, idealTypeList: [IdealTypeResponseList], interestsList: [IdealTypeResponseList], userProfilePhotos: [UserProfilePhoto]) {
    self.username = username
    self.userUUID = userUUID
    self.age = age
    self.introduction = introduction
    self.address = address
    self.phoneNumber = phoneNumber
    self.email = email
    self.idealTypeList = idealTypeList
    self.interestsList = interestsList
    self.userProfilePhotos = userProfilePhotos
  }
}
public struct IdealTypeResponseList: Codable {
  let idx: Int
  let name, emojiCode: String
}

public extension IdealTypeResponseList {
  func toEmoji() -> EmojiType {
    EmojiType(idx: self.idx, name: self.name, emojiCode: self.emojiCode)
  }
}

// MARK: - List
public struct EmojiType {
  public let identifier = UUID()
  public let idx: Int
  public let name, emojiCode: String

  public init(idx: Int, name: String, emojiCode: String) {
    self.idx = idx
    self.name = name
    self.emojiCode = emojiCode
  }
}

// MARK: - UserProfilePhoto
public struct UserProfilePhoto: Codable {
  public let url: String
  public let priority: Int 

  public init(url: String, priority: Int) {
    self.url = url
    self.priority = priority
  }
}

public extension UserProfilePhoto {
  func toDomain() -> ProfilePhotoDomain {
    ProfilePhotoDomain(url: self.url, priority: self.priority)
  }
}

public struct ProfilePhotoDomain: Hashable {
  public let identifier = UUID()
  public let url: String
  public let priority: Int

  public init(url: String, priority: Int) {
    self.url = url
    self.priority = priority
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
}
