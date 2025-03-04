//
//  IdelTypeRes.swift
//  Data
//
//  Created by Kanghos on 2024/01/16.
//

import Foundation

import Domain

public struct IdealTypeResponseList: Codable {
  let idx: Int
  let name: String
  let emojiCode: String
}

public extension IdealTypeResponseList {
  func toDomain() -> EmojiType {
    EmojiType(idx: self.idx, name: self.name, emojiCode: self.emojiCode)
  }
}
