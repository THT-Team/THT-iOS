//
//  HeartListRequest.swift
//  Falling
//
//  Created by Kanghos on 2023/09/11.
//

import Foundation

struct HeartListRequest: Codable {
  let size: Int
  let lastFallingTopicIdx: Int?
  let lastLikeIdx: Int?

  init(size: Int = 100, lastFallingTopicIdx: Int? = nil, lastLikeIdx: Int? = nil) {
    self.size = size
    self.lastFallingTopicIdx = lastFallingTopicIdx
    self.lastLikeIdx = lastLikeIdx
  }
}
