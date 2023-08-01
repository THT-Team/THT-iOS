//
//  LoginRequest.swift
//  Falling
//
//  Created by Kanghos on 2023/08/01.
//

import Foundation

struct LoginRequest: Codable {
    let phoneNumber: String
    let deviceKey: Int

  enum CodingKeys: String, CodingKey {
      case phoneNumber, deviceKey
  }
}
