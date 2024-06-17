//
//  AuthError.swift
//  AuthInterface
//
//  Created by Kanghos on 6/6/24.
//

import Foundation

public enum AuthError: Error {
  case invalidToken
  case tokenNotFound

  var message: String {
    switch self {
    case .invalidToken:
      return "올바르지 않은 토큰입니다."
    case .tokenNotFound:
      return "토큰을 찾을 수 없습니다."
    }
  }
}
