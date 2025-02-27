//
//  AuthFactory.swift
//  Auth
//
//  Created by Kanghos on 8/20/24.
//

import Foundation
import Core

// MARK: PhoneNumber
public protocol PhoneNumberViewModelType: ViewModelType {
  var onPhoneNumberInput: ((String) -> Void)? { get set }
  var onBackButtonTap: (() -> Void)? { get set }
}
public typealias PhoneNumberPresentable = (ViewControllable, any PhoneNumberViewModelType)

// MARK: PhoneAuth
public protocol PhoneNumberAuthViewModelType: ViewModelType {
  var onSuccess: ((String) -> Void)? { get set }
}

public typealias PhoneAuthPresentable = (ViewControllable, any PhoneNumberAuthViewModelType)

public protocol PhoneNumberFactoryType {
  func makePhoneNumberScene() -> PhoneNumberPresentable
  func makePhoneAuthScene(phoneNumber: String) -> PhoneAuthPresentable
}
