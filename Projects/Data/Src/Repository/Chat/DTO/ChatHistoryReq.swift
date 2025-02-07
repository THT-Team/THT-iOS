//
//  ChatHistoryReq.swift
//  Data
//
//  Created by Kanghos on 1/6/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation

struct ChatHistoryReq: Encodable {
  let roomNo: String
  let chatIndex: String?
  let size: Int

  enum CodingKeys: String, CodingKey {
    case roomNo
    case chatIdx = "chatIndex"
    case size
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.roomNo, forKey: .roomNo)
    try container.encodeIfPresent(self.chatIndex, forKey: .chatIdx)
    try container.encode(self.size, forKey: .size)
  }
}
