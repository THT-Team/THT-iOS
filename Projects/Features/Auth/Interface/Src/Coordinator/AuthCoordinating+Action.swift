//
//  AuthCoordinating+Action.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

public enum AuthCoordinatingAction {
  case tologinType(_ type: SNSType)
  case toSignUp(phoneNumber: String)
  case toMain
}
