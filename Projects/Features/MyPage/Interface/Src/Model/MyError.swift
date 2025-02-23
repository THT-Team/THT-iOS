//
//  MyError.swift
//  MyPageInterface
//
//  Created by Kanghos on 2/22/25.
//

import Foundation

public enum MyPageError: Error, LocalizedError {
  case invalidNickname
  case duplicateNickname

  public var errorDescription: String? {
    switch self {
    case .invalidNickname:
      return "닉네임은 5자 이상 입력해주세요."
    case .duplicateNickname:
      return "중복된 닉네임입니다."
    }
  }
}
