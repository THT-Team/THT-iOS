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
  case updateDeviceToken(deviceKey: String)
}

extension AuthTarget: BaseTargetType {

  public var path: String {
    switch self {
    case .certificate(let phoneNumber):
      return "users/join/certification/phone-number/\(phoneNumber)"
    case .checkExistence(let phoneNumber):
      return "users/join/exist/user-info/\(phoneNumber)"
    case .updateDeviceToken:
      return "user/device-key"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .certificate, .checkExistence: return .get
    case .updateDeviceToken: return .patch
    }
  }

  // Request의 파라미터를 결정한다.
  public var task: Task {
    switch self {
    case .updateDeviceToken(let deviceKey):
      return .requestParameters(parameters: ["deviceKey": deviceKey], encoding: JSONEncoding.default)
    default:
      return .requestPlain
    }
  }
}
