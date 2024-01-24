//
//  EmojiSection.swift
//  Like
//
//  Created by Kanghos on 2023/12/20.
//

import Domain

enum ProfileDetailSection {
  case interest
  case idealType
  case introduce
}

extension EmojiType: Hashable {
  public static func == (lhs: EmojiType, rhs: EmojiType) -> Bool {
    lhs.identifier == rhs.identifier
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
}

public struct ProfileInfoSection {
  public typealias Item = EmojiType

  public var items: [Item]
  public var header: String
  public var introduce: String?

  public init(header: String, items: [Item]) {
    self.items = items
    self.header = header
    self.introduce = nil
  }

  public init(header: String, introduce: String) {
    self.items = []
    self.header = header
    self.introduce = introduce
  }
}
