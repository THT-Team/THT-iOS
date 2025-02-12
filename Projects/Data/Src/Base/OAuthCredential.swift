//
//  OAuthCredential.swift
//  Data
//
//  Created by Kanghos on 6/6/24.
//

import Foundation
import AuthInterface
import Domain
import Alamofire

struct OAuthCredential: AuthenticationCredential {
  let accessToken: String
  let accessTokenExpiresIn: Double
  let userUuid: String
  var requiresRefresh: Bool { false }
}

extension Token {
  func toAuthOCredential() -> OAuthCredential {
    OAuthCredential(accessToken: accessToken, accessTokenExpiresIn: accessTokenExpiresIn, userUuid: userUuid)
  }
}

extension OAuthCredential {
  func toToken() -> Token {
    Token(accessToken: accessToken, accessTokenExpiresIn: accessTokenExpiresIn, userUuid: userUuid)
  }
}
