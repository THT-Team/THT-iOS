//
//  SignUpTarget.swift
//  Data
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

import Networks

import Moya
import SignUpInterface

public enum SignUpTarget {
  case checkNickname(nickname: String)
  case agreement
}

extension SignUpTarget: BaseTargetType {

  public var path: String {
    switch self {

    case .checkNickname(let nickname):
      return "users/join/nick-name/duplicate-check/\(nickname)"
    case .agreement:
      return "users/join/agreements/main-category"
    }
  }

  public var method: Moya.Method {
    switch self {
    default: return .get
    }
  }

  // Request의 파라미터를 결정한다.
  public var task: Task {
    switch self {
    default:
      return .requestPlain
    }
  }
}
