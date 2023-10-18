//
//  EmojiSection.swift
//  Falling
//
//  Created by Kanghos on 2023/10/05.
//

import Foundation

import RxDataSources

enum ProfileDetailSection {
  case interest
  case idealType
  case introduce
}

extension EmojiType: Hashable {
  static func == (lhs: EmojiType, rhs: EmojiType) -> Bool {
    lhs.identifier == rhs.identifier
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
}

struct profileInfoSection: SectionModelType {
  init(original: profileInfoSection, items: [EmojiType]) {
    self = original
    self.items = items
    self.introduce = nil
  }
  init(header: String, items: [EmojiType]) {
    self.items = items
    self.header = header
    self.introduce = nil
  }

  init(header: String, introduce: String) {
    self.items = []
    self.header = header
    self.introduce = introduce
  }

  typealias Item = EmojiType
  var items: [Item]
  var header: String
  var introduce: String?
}
