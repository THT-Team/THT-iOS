//
//  UserSNSSignUpRequest.swift
//  Auth
//
//  Created by Kanghos on 12/19/24.
//

import Foundation

public struct UserSNSSignUpRequest: Codable {
  let email: String
  let phoneNumber: String
  let snsUniqueId: String
  let snsType: SNSType

  public init(email: String, phoneNumber: String, snsUniqueId: String, snsType: SNSType) {
    self.email = email
    self.phoneNumber = phoneNumber
    self.snsUniqueId = snsUniqueId
    self.snsType = snsType
  }
}
