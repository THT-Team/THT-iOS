//
//  String+Util.swift
//  Falling
//
//  Created by Kanghos on 2023/10/13.
//

import Foundation

extension String {
  func unicodeToEmoji() -> String {
    guard let hex = Int(self, radix: 16),
          let scalar = UnicodeScalar(hex)
    else {
      return "🧩"
    }
    return String(scalar)
  }
}
