//
//  AuthTarget.swift
//  Data
//
//  Created by Kanghos on 6/3/24.
//

import Foundation

import Networks

import Moya
import AuthInterface

public enum AuthTarget {
  case certificate(phoneNumber: String)
  case checkExistence(phoneNumber: String)
  case login(phoneNumber: String, deviceKey: String)
  case loginSNS(request: UserSNSLoginRequest)
  case refresh(Token)
}

extension AuthTarget: BaseTargetType {

  public var path: String {
    switch self {
    case .certificate(let phoneNumber):
      return "users/join/certification/phone-number/\(phoneNumber)"
    case .checkExistence(let phoneNumber):
      return "users/join/exist/user-info/\(phoneNumber)"
    case .login:
      return "users/login/normal"
    case .loginSNS:
      return "users/login/sns"
    case .refresh:
      return "users/login/refresh"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .certificate, .checkExistence: return .get
    default: return .post
    }
  }

  // Request의 파라미터를 결정한다.
  public var task: Task {
    switch self {
    case let .login(phoneNumber, deviceKey):
      let request = LoginReq(phoneNumber: phoneNumber, deviceKey: deviceKey)
      return .requestParameters(parameters: request.toDictionary(), encoding: JSONEncoding.default)
    case let .loginSNS(snsDTO):
      return .requestParameters(parameters: snsDTO.toDictionary(), encoding: JSONEncoding.default)
    case let .refresh(token):
      return .requestParameters(parameters: token.toDictionary(), encoding: JSONEncoding.default)
    default:
      return .requestPlain
    }
  }
}
