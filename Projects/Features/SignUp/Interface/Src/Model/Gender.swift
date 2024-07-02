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
  case bisexual = "BISEXUAL"

  public init?(number: Int) {
    switch number {
    case 1:
      self = .male
    case 0:
      self = .female
    case 2:
      self = .bisexual
    default:
      return nil
    }
  }
}
extension Gender: TFTitlePropertyType {
  public var title: String {
    switch self {
    case .male: return "남성"
    case .female: return "여성"
    case .bisexual: return "모두"
    }
  }
}

extension Gender: CaseIterable { }
