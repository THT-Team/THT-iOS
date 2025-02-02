//
//  Like.swift
//  Like
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation

public struct Like {
  public let identifier = UUID()
  public let dailyFallingIdx, likeIdx: Int
  public let topic, issue, userUUID, username: String
  public let profileURL: String
  public let age: Int
  public let address, receivedTime: String
  public var isNew: Bool

  public init(dailyFallingIdx: Int, likeIdx: Int, topic: String, issue: String, userUUID: String, username: String, profileURL: String, age: Int, address: String, receivedTime: String) {
    self.dailyFallingIdx = dailyFallingIdx
    self.likeIdx = likeIdx
    self.topic = topic
    self.issue = issue
    self.userUUID = userUUID
    self.username = username
    self.profileURL = profileURL
    self.age = age
    self.address = address
    self.receivedTime = receivedTime
    self.isNew = true
  }

  public mutating func updateNew() {
    self.isNew = false
  }
}

extension Like: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }

  public static func == (lhs: Like, rhs: Like) -> Bool {
    lhs.identifier == rhs.identifier
  }
}
