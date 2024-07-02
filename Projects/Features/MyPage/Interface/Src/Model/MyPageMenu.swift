//
//  MyPageMenu.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/13/24.
//

import Foundation
import SignUpInterface
import Core
import Domain

public enum MyPageSection {
  case birthday(String)
  case gender(Gender)
  case introduction(String)
  case preferGender(Gender, BottomSheetListener)
  case height(Int, BottomSheetListener)
  case smoking(Frequency, BottomSheetListener)
  case drinking(Frequency, BottomSheetListener)
  case religion(Religion, BottomSheetListener)
  case interest([EmojiType], BottomSheetListener)
  case idealType([EmojiType], BottomSheetListener)
}

extension MyPageSection {
  public var title: String {
    switch self {
    case .birthday:
      return "생년월일"
    case .gender:
      return "성별"
    case .introduction:
      return "자기소개"
    case .preferGender:
      return "선호성별"
    case .height:
      return "키"
    case .smoking:
      return "흡연여부"
    case .drinking:
      return "술"
    case .religion:
      return "종교"
    case .interest:
      return "관심사"
    case .idealType:
      return "이상형"
    }
  }
}
