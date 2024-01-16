//
//  FallingUser.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

public enum FallingProfileSection {
  case profile
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
  public let idealTypeResponseList, interestResponses: [IdealType]
  public let userProfilePhotos: [UserProfilePhoto]
  public let introduction: String
  public let userDailyFallingCourserIdx: Int
  
  public init(username: String, userUUID: String, age: Int, address: String, isBirthDay: Bool, idealTypeResponseList: [IdealType], interestResponses: [IdealType], userProfilePhotos: [UserProfilePhoto], introduction: String, userDailyFallingCourserIdx: Int) {
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

public struct IdealType {
  public let identifier = UUID()
  public let idx: Int
  public let name, emojiCode: String
  
  public init(idx: Int, name: String, emojiCode: String) {
    self.idx = idx
    self.name = name
    self.emojiCode = emojiCode
  }
}

extension IdealType: Hashable {
  public static func == (lhs: IdealType, rhs: IdealType) -> Bool {
    lhs.identifier == rhs.identifier
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
}

public struct ProfileInfoSection {
  public typealias Item = IdealType
  
  public var items: [Item]
  public var header: String
  public var introduce: String?
  
  public init(header: String, items: [Item]) {
    self.items = items
    self.header = header
    self.introduce = nil
  }
  
  public init(header: String, introduce: String) {
    self.items = []
    self.header = header
    self.introduce = introduce
  }
}

// MARK: - UserProfilePhoto
public struct UserProfilePhoto {
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
