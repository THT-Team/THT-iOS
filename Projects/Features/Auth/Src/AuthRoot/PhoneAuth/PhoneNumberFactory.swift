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

public final class PhoneNumberFactory: PhoneNumberFactoryType {
  @Injected private var useCase: AuthUseCaseInterface

  public init() { }

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
}
