//
//  EmojiType.swift
//  ProjectDescriptionHelpers
//
//  Created by Kanghos on 2024/01/14.
//

import Foundation

// MARK: - List
public struct EmojiType {

  public let idx: Int
  public let name, emojiCode: String

  public init(idx: Int, name: String, emojiCode: String) {
    self.idx = idx
    self.name = name
    self.emojiCode = emojiCode
  }
}

extension EmojiType: Hashable {
  public var identifier: Int {
    return idx
  }
  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
  public static func == (lhs: EmojiType, rhs: EmojiType) -> Bool {
    lhs.identifier == rhs.identifier
  }
}
