//
//  SNSType.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation

public enum SNSType: String, Codable {
  case kakao = "KAKAO"
  case naver = "NAVER"
  case google = "GOOGLE"
  case apple = "APPLE"
  case normal = "NORMAL"
}

public enum AuthType {
  case phoneNumber
  case sns(SNSUserInfo)

  public var snsType: SNSType {
    switch self {
    case .phoneNumber:
      return .normal
    case .sns(let sns):
      return sns.snsType
    }
  }
}

public struct SNSUserInfo {
  public let snsType: SNSType
  public let id: String
  public let email: String?
  public let phoneNumber: String?

  public init(snsType: SNSType, id: String, email: String?, phoneNumber: String?) {
    self.snsType = snsType
    self.id = id
    self.email = email
    self.phoneNumber = phoneNumber
  }
}
