//
//  FallingUser.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

public enum ProfileSection {
  case profile
}

public enum UserInfoSection: Int {
  case interest
  case ideal
  case introduction
  
  public var title: String {
    switch self {
    case .interest:
      return "내 관심사"
    case .ideal:
      return "내 이상형"
    case .introduction:
      return "자기소개"
    }
  }
}

public enum UserInfoItem: Hashable {
  case interest(EmojiType)
  case ideal(EmojiType)
  case introduction(String)
  
  public var item: Any {
    switch self {
    case .interest(let item), .ideal(let item):
      return item
    case .introduction(let item):
      return item
    }
  }
}
