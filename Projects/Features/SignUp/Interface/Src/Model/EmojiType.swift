//
//  EmojiType.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

public struct EmojiTypeRes: Codable {
  public let index: Int
  public let name: String
  public let emojiCode: String
  
  enum CodingKeys: String, CodingKey {
    case index = "idx"
    case name, emojiCode
  }
  
  public init(index: Int, name: String, emojiCode: String) {
    self.index = index
    self.name = name
    self.emojiCode = emojiCode
  }
}
