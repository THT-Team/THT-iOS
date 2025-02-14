//
//  AuthCoordinator.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//
import UIKit
import Foundation

import Core
import AuthInterface
import Domain

public final class AuthCoordinator: BaseCoordinator, AuthCoordinating {

  // MARK: Signal
  public var phoneNumberVerified: ((String) -> Void)?

  public var finishFlow: ((AuthCoordinatorOutput) -> Void)?

  public let factory: AuthFactoryType

  public init(
    factory: AuthFactoryType = AuthFactory(),
    viewControllable: ViewControllable
  ) {
    self.factory = factory
    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    replaceWindowRootViewController(rootViewController: self.viewControllable)
    launchFlow()
  }

  public func launchFlow() {
    var (vc, vm) = factory.launchFlow()

    vm.onAuthResult = { [weak self] result in
      switch result {
      case .needAuth:
        self?.rootFlow()
      case .toMain:
        self?.finishFlow?(.toMain)
      }
    }
    self.viewControllable.setViewControllers([vc])
  }

  // MARK: 인증 토큰 재발급 또는 가입 시
  public func rootFlow() {
    var (vc, vm) = factory.rootFlow()

    vm.onPhoneNumberAuthFlow = {
      self.phoneNumberInputFlow()
    }

    vm.onSignUpFlow = { [weak self] userInfo in
      self?.viewControllable.popViewController(animated: false)
      self?.finishFlow?(.toSignUp(userInfo))
    }

    vm.onMainFlow = { [weak self] in
      self?.viewControllable.popToRootViewController(animated: true)
      self?.finishFlow?(.toMain)
    }

    vm.onInquiryFlow = {
      self.inquiryFlow()
    }

    self.phoneNumberVerified = {
      vm.onPhoneNumberVerified($0)
    }

    self.viewControllable.setViewControllers([vc])
  }
}

extension AuthCoordinator {

  func phoneNumberInputFlow() {
    var (vc, vm) = factory.makePhoneNumberScene()

    vm.onBackButtonTap = {
      self.viewControllable.popViewController(animated: true)
    }
    vm.onPhoneNumberInput = { phoneNumber in
      self.phoneNumberAuthFlow(phoneNumber: phoneNumber)
    }

    self.viewControllable.pushViewController(vc, animated: true)
  }

  func phoneNumberAuthFlow(phoneNumber: String) {
    var (vc, vm) = factory.makePhoneAuthScene(phoneNumber: phoneNumber)

    vm.onSuccess = { phoneNumber in
      self.phoneNumberVerified?(phoneNumber)
    }

    self.viewControllable.pushViewController(vc, animated: true)
  }
}

extension AuthCoordinator {
  func inquiryFlow() {
    var (vc, vm) = factory.inquiryFlow()
    vm.onBackButtonTap = {
      self.viewControllable.popViewController(animated: true)
    }
    self.viewControllable.pushViewController(vc, animated: true)
  }
}
