//
//  AuthCoordinating.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

import Core
import Domain

public enum AuthCoordinatorOutput {
  case toMain
  case toSignUp(SNSUserInfo)
}

public protocol AuthCoordinating: Coordinator {
  var finishFlow: ((AuthCoordinatorOutput) -> Void)? { get set }

  var phoneNumberVerified: ((String) -> Void)? { get set }

  func rootFlow()
}
