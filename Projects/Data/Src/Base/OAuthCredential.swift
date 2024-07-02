//
//  OAuthCredential.swift
//  Data
//
//  Created by Kanghos on 6/6/24.
//

import Foundation
import AuthInterface

import Alamofire

struct OAuthCredential: AuthenticationCredential {
  let accessToken: String
  let accessTokenExpiresIn: Double
  var requiresRefresh: Bool { false }
}

extension Token {
  func toAuthOCredential() -> OAuthCredential {
    OAuthCredential(accessToken: accessToken, accessTokenExpiresIn: accessTokenExpiresIn)
  }
}

extension OAuthCredential {
  func toToken() -> Token {
    Token(accessToken: accessToken, accessTokenExpiresIn: accessTokenExpiresIn)
  }
}
