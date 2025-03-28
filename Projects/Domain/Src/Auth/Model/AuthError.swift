//
//  AuthError.swift
//  AuthInterface
//
//  Created by Kanghos on 6/6/24.
//

import Foundation

public enum AuthError: Error, LocalizedError {
  case invalidToken
  case tokenNotFound
  case invalidDeviceKey
  case invalidSNSUser
  case canNotOpenSNSURL
  case tokenRefreshFailed
  case phoneNumberNotFound

  case internalError
  case custom(String)

  public var errorDescription: String? {
    switch self {
    case .invalidToken:
      return "올바르지 않은 토큰입니다."
    case .tokenNotFound:
      return "토큰을 찾을 수 없습니다."
    case .invalidDeviceKey:
      return "디바이스 토큰 등록에 실패하였습니다."
    case .invalidSNSUser:
      return "유효하지 않은 SNS 유저입니다."
    case .canNotOpenSNSURL:
      return "URL을 열 수 없습니다."
    case .tokenRefreshFailed:
      return "토큰 갱신에 실패하였습니다."
    case .phoneNumberNotFound:
      return "휴대폰 번호를 찾을 수 없습니다."
    case .internalError:
      return "Unknown Internal Error"
    case .custom(let msg): return msg
    }
  }
}
