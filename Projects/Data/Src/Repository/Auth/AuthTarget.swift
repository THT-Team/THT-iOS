//
//  AuthTarget.swift
//  Data
//
//  Created by Kanghos on 6/3/24.
//

import Foundation

import Networks

import Moya

public enum AuthTarget {
  case certificate(phoneNumber: String)
  case checkExistence(phoneNumber: String)
}

extension AuthTarget: BaseTargetType {

  public var path: String {
    switch self {
    case .certificate(let phoneNumber):
      return "users/join/certification/phone-number/\(phoneNumber)"
    case .checkExistence(let phoneNumber):
      return "users/join/exist/user-info/\(phoneNumber)"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .certificate, .checkExistence: return .get
    }
  }

  public var headers: [String : String]? {
    return nil
  }

  // Request의 파라미터를 결정한다.
  public var task: Task {
    switch self {

    default:
      return .requestPlain
    }
  }

  public var sampleData: Data {
    switch self {
    case .certificate(let phoneNumber):
      return Data()
    case .checkExistence(let phoneNumber):
      return Data("""
{"isSignUp":true,"typeList":["NORMAL","KAKAO", "APPLE"]}
""".utf8)
    }
  }
}
