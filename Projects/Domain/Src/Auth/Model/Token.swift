//
//  Token.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

public struct Token: Codable {
  public let accessToken: String
  public let accessTokenExpiresIn: Double
  public let userUuid: String

  public init(accessToken: String, accessTokenExpiresIn: Double, userUuid: String) {
    self.accessToken = accessToken
    self.accessTokenExpiresIn = accessTokenExpiresIn
    self.userUuid = userUuid
  }
}
