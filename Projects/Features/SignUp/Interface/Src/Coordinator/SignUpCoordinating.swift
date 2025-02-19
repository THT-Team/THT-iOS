//
//  SIgnUpCoordinating.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core
import AuthInterface
import Domain

public protocol SignUpAlertCoordinating {
  func showTopBottomAlert(_ listener: TopBottomAlertListener)
}

public enum SignUpOption {
  case start(phoneNumber: String)
  case startPolicy(SNSUserInfo)
}

public enum FinishSignUpOption {
  case back
  case complete
}

public protocol SignUpCoordinatorDelegate: AnyObject {
  func detachSignUp(_ coordinator: Coordinator, _ option: FinishSignUpOption)
  func attachSignUp(_ option: SignUpOption)
}

public protocol SignUpCoordinating: Coordinator, SignUpAlertCoordinating {
  var delegate: SignUpCoordinatorDelegate? { get set }
  var finishFlow: ((FinishSignUpOption) -> Void)? { get set }

  func start(_ user: PendingUser)

  func nicknameFlow(user: PendingUser)
  func emailFlow(user: PendingUser)
  func policyFlow(user: PendingUser)
  func genderPickerFlow(user: PendingUser)
  func preferGenderPickerFlow(user: PendingUser)
  func photoFlow(user: PendingUser)

  func heightFlow(user: PendingUser)
  func drinkAndSmokeFlow(user: PendingUser)
  func religionFlow(user: PendingUser)

  func idealTypeFlow(user: PendingUser)
  func interestFlow(user: PendingUser)
  func introduceFlow(user: PendingUser)
  func locationFlow(user: PendingUser)
  func blockUserFlow(user: PendingUser)
  func signUpCompleteFlow(user: PendingUser)
}
