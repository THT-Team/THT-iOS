//
//  ContactType.swift
//  SignUpInterface
//
//  Created by Kanghos on 5/12/24.
//

import Foundation

public struct ContactType: Codable {
  public let name: String
  public let phoneNumber: String

  public init(name: String, phoneNumber: String) {
    self.name = name
    self.phoneNumber = phoneNumber
  }
}
