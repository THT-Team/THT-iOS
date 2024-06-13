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
  case certificate(phoneNumber: String)
  case checkExistence(phoneNumber: String)
  case checkNickname(nickname: String)
  case idealTypes
  case interests
  case block(contacts: UserFriendContactReq)
  case signUp(signUpReq: SignUpReq)
  case agreement
}

extension SignUpTarget: BaseTargetType {

  public var path: String {
    switch self {
    case .certificate(let phoneNumber):
      return "users/join/certification/phone-number/\(phoneNumber)"
    case .checkExistence(let phoneNumber):
      return "users/join/exist/user-info/\(phoneNumber)"
    case .checkNickname(let nickname):
      return "users/join/nick-name/duplicate-check/\(nickname)"
    case .idealTypes:
      return "ideal-types"
    case .interests:
      return "interests"
    case .block:
      return "user/friend-contact-list"
    case .signUp:
      return "users/join/signup"
    case .agreement:
      return "users/join/agreements/main-category"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .block:
      return .post
    case .signUp:
      return .post
    default: return .get
    }
  }

  // Request의 파라미터를 결정한다.
  public var task: Task {
    switch self {
    case let .block(contacts):
      return .requestParameters(parameters: contacts.toDictionary(), encoding: JSONEncoding.default)
    case let .signUp(dto):
      return .requestParameters(parameters: dto.toDictionary(), encoding: JSONEncoding.default)
    default:
      return .requestPlain
    }
  }
}
