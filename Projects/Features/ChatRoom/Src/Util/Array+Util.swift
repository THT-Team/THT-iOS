//
//  Array+Util.swift
//  ChatRoom
//
//  Created by Kanghos on 2/27/25.
//

import Foundation

extension Array where Element == ChatViewSectionItem {
  mutating func appendItem(_ item: Element) {
    var mutable = self
    mutable.append(item)
    self = mutable
  }

  mutating func append(_ items: [Element]) {
    var mutable = self
    mutable.append(contentsOf: items)
    self = mutable
  }

  mutating func insert(_ items: [Element]) {
    var mutable = items
    mutable.append(contentsOf: self)
    self = mutable
  }
}
