//
//  TokenProviderTarget.swift
//  Data
//
//  Created by Kanghos on 6/5/24.
//

import Foundation

import Networks

import Moya
import AuthInterface

public enum TokenProviderTarget {
  case login(phoneNumber: String, deviceKey: String)
  case loginSNS(request: UserSNSLoginRequest)
  case refresh(Token)
}

extension TokenProviderTarget: BaseTargetType {

  public var path: String {
    switch self {
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
    }
  }
}
