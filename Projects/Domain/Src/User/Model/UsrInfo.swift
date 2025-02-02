//
//  UsrInfo.swift
//  Domain
//
//  Created by Kanghos on 2024/01/16.
//

import Foundation

public protocol UserInfoType {
  var username: String { get }
  var userUUID: String { get }
  var age: Int { get }
  var introduction: String { get }
  var address: String { get }
  var idealTypeList: [EmojiType] { get }
  var interestsList: [EmojiType] { get }
  var userProfilePhotos: [UserProfilePhoto] { get }
}

// MARK: - UserResponse
public struct UserInfo: UserInfoType {
  public let username, userUUID: String
  public let age: Int
  public let introduction, address: String
  public let idealTypeList, interestsList: [EmojiType]
  public let userProfilePhotos: [UserProfilePhoto]

  public let phoneNumber, email: String

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
