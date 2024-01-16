//
//  UserProfilePhoto.swift
//  Domain
//
//  Created by Kanghos on 2024/01/16.
//

import Foundation

public struct UserProfilePhoto {
  public let identifier = UUID()
  public let url: String
  public let priority: Int

  public init(url: String, priority: Int) {
    self.url = url
    self.priority = priority
  }
}

extension UserProfilePhoto: Hashable {

  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
}
