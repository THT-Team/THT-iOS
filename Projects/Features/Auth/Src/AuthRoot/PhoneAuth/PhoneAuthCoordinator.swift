//
//  File.swift
//  Auth
//
//  Created by Kanghos on 12/16/24.
//

import Foundation

import Core
import AuthInterface

public protocol PhoneAuthCoordinating {
  func phoneNumberInputFlow()
  func phoneNumberAuthFlow(phoneNumber: String)
}

public final class PhoneAuthCoordinator: BaseCoordinator {
  let factory: PhoneNumberFactoryType

  public init(factory: PhoneNumberFactoryType = PhoneNumberFactory(), rootViewControllable: ViewControllable) {
    self.factory = factory
    super.init(viewControllable: rootViewControllable)
  }

  public var finishFlow: (() -> Void)?
  public var onAuthenticateSuccess: ((String) -> Void)?

  public override func start() {
    //    replaceWindowRootViewController(rootViewController: self.viewControllable)
    phoneNumberInputFlow()
  }
}

extension PhoneAuthCoordinator: PhoneAuthCoordinating {
  public func phoneNumberInputFlow() {
    var (vc, vm) = factory.makePhoneNumberScene()
    vm.onPhoneNumberInput = { [weak self] phoneNumber in
      guard let self else { return }
      self.phoneNumberAuthFlow(phoneNumber: phoneNumber)
    }

    vm.onBackButtonTap = { [weak self] in
      guard let self else { return }
      self.finishFlow?()
    }

    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func phoneNumberAuthFlow(phoneNumber: String) {
    var (vc, vm) = factory.makePhoneAuthScene(phoneNumber: phoneNumber)
    vm.onSuccess = { [weak self] phoneNumber in
      self?.onAuthenticateSuccess?(phoneNumber)
    }

    self.viewControllable.pushViewController(vc, animated: true)
  }
}
