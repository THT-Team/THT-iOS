//
//  UsrInfo.swift
//  Domain
//
//  Created by Kanghos on 2024/01/16.
//

import Foundation

// MARK: - UserResponse
public struct UserInfo {
  public let username, userUUID: String
  public let age: Int
  public let introduction, address, phoneNumber, email: String
  public let idealTypeList, interestsList: [EmojiType]
  public let userProfilePhotos: [UserProfilePhoto]

  enum CodingKeys: String, CodingKey {
    case username
    case userUUID = "userUuid"
    case age, introduction, address, phoneNumber, email, idealTypeList, interestsList, userProfilePhotos
  }

  public var description: String {
    username + ", " + "\(age)"
  }

  public init(username: String, userUUID: String, age: Int, introduction: String, address: String, phoneNumber: String, email: String, idealTypeList: [EmojiType], interestsList: [EmojiType], userProfilePhotos: [UserProfilePhoto]) {
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
