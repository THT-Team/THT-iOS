//
//  AuthCoordinating+Action.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

public enum AuthCoordinatingAction {
  case tologinType(_ type: AuthType)
  case toMain
  case inquiry
}


public enum PhoneAuthOption {
  case signUp(phoneNumber: String)
  case signIn
  case none
}
public protocol PhoneAuthViewDelegate: AnyObject {
  func didAuthComplete(option: PhoneAuthOption)
}
