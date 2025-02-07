//
//  AuthResult.swift
//  AuthInterface
//
//  Created by Kanghos on 12/15/24.
//

import Foundation

// AuthRootNavigation
public enum AuthNavigation {
  case phoneNumber(SNSUserInfo)
  case signUp(SNSUserInfo)
  case main
}
