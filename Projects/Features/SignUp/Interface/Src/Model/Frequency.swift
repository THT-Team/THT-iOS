//
//  Frequency.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation

public enum Frequency: String, Codable {
  case sometimes = "SOMETIMES"
  case frequently = "FREQUENTLY"
  case none = "NONE"

  public init?(number: Int) {
    switch number {
    case 0:
      self = .sometimes
    case 1:
      self = .frequently
    case 2:
      self = .none
    default:
      return nil
    }
  }
}

extension Frequency {
  public var title: String {
    switch self {
    case .sometimes:
      return "가끔"
    case .frequently:
      return "자주"
    case .none:
      return "안 함"
    }
  }
}
