//
//  PhoneNumberFactory.swift
//  Auth
//
//  Created by Kanghos on 12/16/24.
//

import Foundation

import Core
import AuthInterface
import Domain

public protocol AuthFactoryType: PhoneNumberFactoryType {
  func rootFlow() -> (ViewControllable, AuthRootOutput)
  func inquiryFlow() -> (ViewControllable, DefaultOutput)
}

public final class AuthFactory {
  @Injected private var useCase: AuthUseCaseInterface

  public init() { }
}

extension AuthFactory: AuthFactoryType {

  public func rootFlow() -> (ViewControllable, AuthRootOutput) {
    let vm = AuthRootViewModel(useCase: useCase)
    let vc = AuthRootViewController()
    vc.viewModel = vm
    vc.modalPresentationStyle = .fullScreen
    vc.modalTransitionStyle = .crossDissolve
    return (vc, vm)
  }

  public func makePhoneNumberScene() -> PhoneNumberPresentable {
    let vm = PhoneNumberInputVM(useCase: useCase)
    let vc = PhoneNumberInputVC(viewModel: vm)

    return (vc, vm)
  }

  public func makePhoneAuthScene(phoneNumber: String) -> PhoneAuthPresentable {
    let vm = PhoneNumberAuthVM(phoneNumber: phoneNumber, useCase: useCase)
    let vc = PhoneNumberAuthVC(viewModel: vm)

    return (vc, vm)
  }

  public func inquiryFlow() -> (any ViewControllable, any DefaultOutput) {
    let vm = InquiryViewModel()
    let vc = InquiryViewController(viewModel: vm)

    return (vc, vm)
  }
}
