//
//  Emoji+Util.swift
//  Core
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation

public extension String {
  func unicodeToEmoji() -> String {
    guard let hex = Int(self.dropFirst(2), radix: 16),
          let scalar = UnicodeScalar(hex)
    else {
      return "🧩"
    }
    return String(scalar)
  }
}
