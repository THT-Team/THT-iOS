//
//  HeartListRequest.swift
//  Falling
//
//  Created by Kanghos on 2023/09/11.
//

import Foundation

public struct HeartListRequest: Codable {
  public let size: Int
  public let lastFallingTopicIdx: Int?
  public let lastLikeIdx: Int?

  public init(size: Int = 100, lastFallingTopicIdx: Int? = nil, lastLikeIdx: Int? = nil) {
    self.size = size
    self.lastFallingTopicIdx = lastFallingTopicIdx
    self.lastLikeIdx = lastLikeIdx
  }
}
