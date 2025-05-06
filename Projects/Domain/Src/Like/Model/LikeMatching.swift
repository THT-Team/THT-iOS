//
//  LikeRes.swift
//  Domain
//
//  Created by Kanghos on 1/5/25.
//

import Foundation

public struct LikeMatching {
  public let isMatching: Bool
  public let chatRoomIdx: Int?

  public init(isMatching: Bool, chatRoomIdx: Int?) {
    self.isMatching = isMatching
    self.chatRoomIdx = chatRoomIdx
  }
}
