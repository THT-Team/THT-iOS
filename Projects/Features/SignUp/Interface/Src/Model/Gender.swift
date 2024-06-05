//
//  Gender.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation

public enum Gender: String, Codable {
  case male = "MALE"
  case female = "FEMALE"
  case both = "BOTH"

  public init?(number: Int) {
    switch number {
    case 1:
      self = .male
    case 0:
      self = .female
    case 2:
      self = .both
    default:
      return nil
    }
  }
}
