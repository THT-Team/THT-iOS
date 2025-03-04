//
//  TokenProviderTarget.swift
//  Data
//
//  Created by Kanghos on 6/5/24.
//

import Foundation

import Networks

import Moya
import Domain

public enum TokenProviderTarget {
  case login(phoneNumber: String, deviceKey: String)
  case loginSNS(request: SNSUserInfo.LoginRequest)
  case refresh(Token)
  case signUp(SignUpReq)
  case signUpSNS(SNSUserInfo.SignUpRequest)
  case updateDeviceToken(deviceKey: String)
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
    case .signUp:
      return "users/join/signup"
    case .signUpSNS:
      return "users/join/signup/sns"
    case .updateDeviceToken:
      return "user/device-key"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .updateDeviceToken: return .patch
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
    case let .signUp(request):
      return .requestJSONEncodable(request)
    case let .signUpSNS(request):
      return .requestJSONEncodable(request)
    case .updateDeviceToken(let deviceKey):
      return .requestParameters(parameters: ["deviceKey": deviceKey], encoding: JSONEncoding.default)
    }
  }
}

extension TokenProviderTarget {
  public var sampleData: Data {

    Data("""
{
"accessToken":"eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhdXRob3JpemF0aW9uIiwidXVpZCI6IjM5N2Q0MmYyNGEtYjdhMC00YmMzLThiYzctZGE4ZDE4ZjU2Mzc2Iiwicm9sZSI6Ik5PUk1BTCIsImlhdCI6MTczOTYxNTY3MywiZXhwIjoxNzQwMjIwNDczfQ.95D9xMr9CJ3xJiL_fpjWoYbGkEpRlMAvyQd9g0hUJyc","accessTokenExpiresIn":1740220473958,"userUuid":"397d42f24a-b7a0-4bc3-8bc7-da8d18f56376"
}
""".utf8)
  }
}
