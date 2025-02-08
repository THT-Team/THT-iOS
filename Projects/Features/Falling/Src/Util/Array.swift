//
//  Array.swift
//  Falling
//
//  Created by Kanghos on 2/8/25.
//

import Foundation

extension Array {
  @discardableResult
  mutating func remove(safeAt index: Index) -> Element? {
    guard self.count > index else { return nil }
    return remove(at: index)
  }

  subscript(safe index: Index) -> Element? {
    guard self.count > index else { return nil }
    return self[index]
  }
}
