//
//  AuthFactory.swift
//  Auth
//
//  Created by Kanghos on 8/20/24.
//

import Foundation
import Core

public protocol AuthVCType: ViewControllable {
  associatedtype ViewModel: AuthViewModelType
}

public protocol PhoneNumberVCType: ViewControllable {
  associatedtype ViewModel
}

public protocol PhoneInputVCDelegate: AnyObject {
  func didTapPhoneInputBtn(_ phoneNumber: String)
}

public protocol PhoneNumberVMType: ViewModelType {
  var delegate: PhoneInputVCDelegate? { get set }
}

public protocol AuthViewFactoryType {
  func makePhoneAuthScene(viewModel: some AuthViewModelType) -> any AuthVCType
  func makePhoneNumberScene(delegate: PhoneInputVCDelegate) -> any PhoneNumberVCType
}


//Factory <- Coordinator <- Builder(Coordinator Factory)

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
