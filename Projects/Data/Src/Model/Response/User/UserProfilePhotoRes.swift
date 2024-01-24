//
//  UserInfoRes.swift
//  Data
//
//  Created by Kanghos on 2024/01/16.
//

import Foundation

import Domain

// MARK: - UserProfilePhoto
public struct UserProfilePhotoRes: Codable {
  public let url: String
  public let priority: Int

  public init(url: String, priority: Int) {
    self.url = url
    self.priority = priority
  }
}

public extension UserProfilePhotoRes {
  func toDomain() -> UserProfilePhoto {
    UserProfilePhoto(url: self.url, priority: self.priority)
  }
}
