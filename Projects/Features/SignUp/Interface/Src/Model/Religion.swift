//
//  Religion.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation

public enum Religion: String, Codable {
  case christian = "CHRISTIAN"
  case catholic = "CATHOLICISM"
  case buddhism = "BUDDHISM"
  case wonBuddhism = "WON_BUDDHISM"
  case none = "NONE"
  case other = "OTHER"
}

extension Religion {
  public var title: String {
    switch self {
    case .christian:
      return "기독교"
    case .catholic:
      return "천주교"
    case .buddhism:
      return "불교"
    case .wonBuddhism:
      return "원불교"
    case .none:
      return "무교"
    case .other:
      return "기타"
    }
  }
}
