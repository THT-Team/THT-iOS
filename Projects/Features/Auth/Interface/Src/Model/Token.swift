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

  public init(accessToken: String, accessTokenExpiresIn: Double) {
    self.accessToken = accessToken
    self.accessTokenExpiresIn = accessTokenExpiresIn
  }
}
