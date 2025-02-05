//
//  UserSNSLoginRequest.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

public struct UserSNSLoginRequest: Codable {
  public let email: String
  public let snsType: SNSType
  public let snsUniqueId: String
  public let deviceKey: String

  public init(email: String, snsType: SNSType, snsUniqueId: String, deviceKey: String) {
    self.email = email
    self.snsType = snsType
    self.snsUniqueId = snsUniqueId
    self.deviceKey = deviceKey
  }
}
