//
//  AuthResult.swift
//  Auth
//
//  Created by Kanghos on 12/19/24.
//

import Foundation
import Domain

public enum AuthResult {
  case signUp(SNSUserInfo)
  case signUpSNS(UserSNSSignUpRequest)
  case login
  case loginSNS(UserSNSLoginRequest)
  case needPhoneNumber
}
