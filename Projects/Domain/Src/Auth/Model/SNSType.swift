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
  case phoneNumber(number: String)
  case kakao
  case naver
  case google
  case apple

  public var snsType: SNSType {
    switch self {
    case .phoneNumber: return .normal
    case .kakao: return .kakao
    case .naver: return .naver
    case .apple: return .apple
    case .google: return .google
    }
  }

  public init?(_ snsType: SNSType) {
    switch snsType {
    case .apple: self = .apple
    case .google: self = .google
    case .kakao: self = .kakao
    case .naver: self = .naver
    case .normal: return nil
    }
  }
}

public enum SocialType {
  case kakao
  case naver
  case apple

  var type: SNSType {
    return .kakao
  }
}

public struct SNSUserInfo: Codable {
  public let snsType: SNSType
  public let id: String
  public let email: String
  public var phoneNumber: String

  public init(snsType: SNSType, id: String, email: String, phoneNumber: String) {
    self.snsType = snsType
    self.id = id
    self.email = email
    self.phoneNumber = phoneNumber
  }
}

extension SNSUserInfo {
  public struct LoginRequest: Encodable {
    public let email: String
    public let snsType: SNSType
    public let snsUniqueId: String
    public let deviceKey: String

    public init(info: SNSUserInfo, deviceKey: String) {
      self.email = info.email
      self.snsType = info.snsType
      self.snsUniqueId = info.id
      self.deviceKey = deviceKey
    }
  }

  public struct SignUpRequest: Encodable {
    let email: String
    let phoneNumber: String
    let snsUniqueId: String
    let snsType: SNSType

    public init(info: SNSUserInfo) {
      self.email = info.email
      self.phoneNumber = info.phoneNumber
      self.snsUniqueId = info.id
      self.snsType = info.snsType
    }
  }
}

