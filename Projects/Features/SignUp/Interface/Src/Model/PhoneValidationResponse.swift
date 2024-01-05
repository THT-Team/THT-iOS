//
//  PhoneCertificationResponse.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/12.
//

import Foundation

public struct PhoneValidationResponse {
  public let phoneNumber: String
  public let authNumber: Int

  public init(phoneNumber: String, authNumber: Int) {
    self.phoneNumber = phoneNumber
    self.authNumber = authNumber
  }
}
