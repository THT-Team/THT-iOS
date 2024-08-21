//
//  AuthFactory.swift
//  Auth
//
//  Created by Kanghos on 8/20/24.
//

import Foundation
import Core

//public typealias PhoneAuthScene = (PhoneAuthVC<T>, AuthViewModelType)

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
