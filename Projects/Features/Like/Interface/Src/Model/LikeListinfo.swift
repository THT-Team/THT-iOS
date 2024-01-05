//
//  LikeListinfo.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation

public struct LikeListinfo {
  public let likeList: [Like]
  public let size, lastFallingTopicIdx, lastLikeIdx: Int

  public init(likeList: [Like], size: Int, lastFallingTopicIdx: Int, lastLikeIdx: Int) {
    self.likeList = likeList
    self.size = size
    self.lastFallingTopicIdx = lastFallingTopicIdx
    self.lastLikeIdx = lastLikeIdx
  }
}
