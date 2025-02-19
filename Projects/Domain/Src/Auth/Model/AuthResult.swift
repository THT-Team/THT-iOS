//
//  AuthResult.swift
//  Auth
//
//  Created by Kanghos on 12/19/24.
//

import Foundation

public enum AuthResult {
  case signUp(SNSUserInfo)
  case signUpSNS(SNSUserInfo)
  case login
  case loginSNS(SNSUserInfo.LoginRequest)
  case needPhoneNumber
}
