//
//  InputTagItemViewModel.swift
//  Domain
//
//  Created by Kanghos on 7/27/24.
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

public struct InputTagItemViewModel {
  public let emojiType: EmojiType
  public var isSelected: Bool

  public var emoji: String {
    return emojiType.emojiCode.unicodeToEmoji()
  }

  public init(item: EmojiType, isSelected: Bool) {
    self.emojiType = item
    self.isSelected = isSelected
  }
}

extension InputTagItemViewModel: Equatable {
  public static func == (lhs: InputTagItemViewModel, rhs: InputTagItemViewModel) -> Bool {
    return lhs.emojiType == rhs.emojiType
  }
}

extension InputTagItemViewModel: Comparable {
  public static func < (lhs: InputTagItemViewModel, rhs: InputTagItemViewModel) -> Bool {
    return lhs.emojiType.idx < rhs.emojiType.idx
  }
}
