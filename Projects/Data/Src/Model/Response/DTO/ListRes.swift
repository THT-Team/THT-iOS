//
//  LikeDTO.swift
//  Data
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation

import Domain

extension LikeListinfo {
  struct Res: Decodable {
    let likeList: [Like.Res]
    let size, lastFallingTopicIdx, lastLikeIdx: Int

    func toDomain() -> LikeListinfo {
      LikeListinfo(
        likeList: self.likeList.map { $0.toDomain() },
        size: self.size,
        lastFallingTopicIdx: self.lastFallingTopicIdx,
        lastLikeIdx: self.lastLikeIdx
      )
    }
  }
}
