//
//  HeartRejectRequest.swift
//  Falling
//
//  Created by Kanghos on 2023/09/11.
//

import Foundation

public struct HeartRejectRequest: Codable {
  public let likeIdx: Int

  public init(likeIdx: Int) {
    self.likeIdx = likeIdx
  }
}
