//
//  FallingUser.swift
//  Domain
//
//  Created by Kanghos on 1/6/25.
//

import Foundation

public struct FallingUser: UserInfoType {
  public let username: String
  public let userUUID: String
  public let age: Int
  public let address: String

  public var idealTypeList: [EmojiType]
  public var interestsList: [EmojiType]
  public let userProfilePhotos: [UserProfilePhoto]
  public let introduction: String

  public let isBirthDay: Bool
  public let userDailyFallingCourserIdx: Int
  public let distance: Int

  public init(username: String, userUUID: String, age: Int, address: String, isBirthDay: Bool, idealTypeResponseList: [EmojiType], interestResponses: [EmojiType], userProfilePhotos: [UserProfilePhoto], introduction: String, userDailyFallingCourserIdx: Int, distance: Int) {
    self.username = username
    self.userUUID = userUUID
    self.age = age
    self.address = address
    self.isBirthDay = isBirthDay
    self.idealTypeList = idealTypeResponseList
    self.interestsList = interestResponses
    self.userProfilePhotos = userProfilePhotos
    self.introduction = introduction
    self.userDailyFallingCourserIdx = userDailyFallingCourserIdx
    self.distance = distance
  }
}

extension FallingUser: Hashable, Equatable {
  public var id: String { return userUUID }
}
