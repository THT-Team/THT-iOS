//
//  EmojiSection.swift
//  Like
//
//  Created by Kanghos on 2023/12/20.
//

import UIKit

import LikeInterface

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

struct ProfileInfoSection {
  typealias Item = EmojiType

  var items: [Item]
  var header: String
  var introduce: String?

  init(header: String, items: [Item]) {
    self.items = items
    self.header = header
    self.introduce = nil
  }

  init(header: String, introduce: String) {
    self.items = []
    self.header = header
    self.introduce = introduce
  }

}
