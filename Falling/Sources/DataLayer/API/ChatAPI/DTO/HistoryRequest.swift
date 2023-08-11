//
//  HistoryRequest.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import Foundation

struct HistoryRequest: Codable {
  let roomNo: String
  let chatIndex: String?
  let size: String

  enum CodingKeys: String, CodingKey {
    case roomNo, size
    case chatIndex = "chatIdx"
  }
}

