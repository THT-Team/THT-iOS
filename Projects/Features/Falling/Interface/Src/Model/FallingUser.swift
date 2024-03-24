//
//  FallingUser.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Foundation
import Domain

public enum FallingProfileSection {
  case profile
}

public enum FallingUserInfoSection: Int {
  case interest
  case ideal
  case introduction
  
  public var title: String {
    switch self {
    case .interest:
      return "내 관심사"
    case .ideal:
      return "내 이상형"
    case .introduction:
      return "자기소개"
    }
  }
}

public enum FallingUserInfoItem: Hashable {
  case interest(EmojiType)
  case ideal(EmojiType)
  case introduction(String)
  
  public var item: Any {
    switch self {
    case .interest(let item), .ideal(let item):
      return item
    case .introduction(let item):
      return item
    }
  }
}

public struct FallingUserInfo {
  public let selectDailyFallingIdx, topicExpirationUnixTime: Int
  public let userInfos: [FallingUser]
  
  public init(selectDailyFallingIdx: Int, topicExpirationUnixTime: Int, userInfos: [FallingUser]) {
    self.selectDailyFallingIdx = selectDailyFallingIdx
    self.topicExpirationUnixTime = topicExpirationUnixTime
    self.userInfos = userInfos
  }
}

public struct FallingUser {
  public let identifer = UUID()
  public let username, userUUID: String
  public let age: Int
  public let address: String
  public let isBirthDay: Bool
  public let idealTypeResponseList, interestResponses: [EmojiType]
  public let userProfilePhotos: [UserProfilePhoto]
  public let introduction: String
  public let userDailyFallingCourserIdx: Int
  
  public init(username: String, userUUID: String, age: Int, address: String, isBirthDay: Bool, idealTypeResponseList: [EmojiType], interestResponses: [EmojiType], userProfilePhotos: [UserProfilePhoto], introduction: String, userDailyFallingCourserIdx: Int) {
    self.username = username
    self.userUUID = userUUID
    self.age = age
    self.address = address
    self.isBirthDay = isBirthDay
    self.idealTypeResponseList = idealTypeResponseList
    self.interestResponses = interestResponses
    self.userProfilePhotos = userProfilePhotos
    self.introduction = introduction
    self.userDailyFallingCourserIdx = userDailyFallingCourserIdx
  }
}

extension FallingUser: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifer)
  }
  public static func == (lhs: FallingUser, rhs: FallingUser) -> Bool {
    lhs.identifer == rhs.identifer
  }
}
