//
//  Frequency.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation

public protocol TFTitlePropertyType {
  var title: String { get }
}

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

  public init?(rawValue: String) {
    switch rawValue {
    case "안 함": self = .none
    case "자주": self = .frequently
    case "가끔": self = .sometimes
    default: return nil
    }
  }
}

extension Frequency: TFTitlePropertyType {
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

extension Frequency: CaseIterable { }
