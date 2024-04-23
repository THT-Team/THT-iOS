//
//  SIgnUpCoordinating.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core

public protocol SignUpCoordinatorDelegate: AnyObject {
  func detachSignUp(_ coordinator: Coordinator)
}

public protocol SignUpCoordinating: Coordinator {
  var delegate: SignUpCoordinatorDelegate? { get set }

  func rootFlow()
  func nicknameFlow()
  func emailFlow()
  func finishFlow()
  func phoneNumberFlow()
  func policyFlow()
  func genderPickerFlow()
  func preferGenderPickerFlow()
  func photoFlow()
}
