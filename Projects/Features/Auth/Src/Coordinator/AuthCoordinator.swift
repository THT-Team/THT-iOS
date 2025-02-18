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
import SignUpInterface
import Domain
import DSKit

public final class AuthCoordinator: BaseCoordinator, AuthCoordinating {

  // MARK: Signal
  public var phoneNumberVerified: ((String) -> Void)?

  public var finishFlow: (() -> Void)?

  public let factory: AuthFactoryType
  private let signUpBuilder: SignUpBuildable

  public init(
    factory: AuthFactoryType = AuthFactory(),
    viewControllable: ViewControllable,
    signUpBuilder: SignUpBuildable
  ) {
    self.factory = factory
    self.signUpBuilder = signUpBuilder
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
        self?.finishFlow?()
      }
    }
    self.viewControllable.setViewControllers([vc])
  }

  // MARK: 인증 토큰 재발급 또는 가입 시
  public func rootFlow() {
    let (vc, vm) = factory.rootFlow()

    vm.onPhoneNumberAuthFlow = { [weak self] in
      self?.phoneNumberInputFlow()
    }

    vm.onSignUpFlow = { [weak self] user in
      self?.viewControllable.popViewController(animated: false)
      self?.runSignUPFlow(user)
    }

    vm.onMainFlow = { [weak self] in
      self?.finishFlow?()
    }

    vm.onInquiryFlow = { [weak self] in
      self?.inquiryFlow()
    }

    self.phoneNumberVerified = { [weak self, weak vm] number in
      vm?.onPhoneNumberVerified(number)
    }

    self.viewControllable.setViewControllers([vc])
  }
}

extension AuthCoordinator {

  func phoneNumberInputFlow() {
    var (vc, vm) = factory.makePhoneNumberScene()

    vm.onBackButtonTap = { [weak self] in
      self?.viewControllable.popViewController(animated: true)
    }
    vm.onPhoneNumberInput = { [weak self] phoneNumber in
      self?.phoneNumberAuthFlow(phoneNumber: phoneNumber)
    }

    self.viewControllable.pushViewController(vc, animated: true)
  }

  func phoneNumberAuthFlow(phoneNumber: String) {
    var (vc, vm) = factory.makePhoneAuthScene(phoneNumber: phoneNumber)

    vm.onSuccess = { [weak self] phoneNumber in
      self?.phoneNumberVerified?(phoneNumber)
    }

    self.viewControllable.pushViewController(vc, animated: true)
  }
}

extension AuthCoordinator {
  func inquiryFlow() {
    var (vc, vm) = factory.inquiryFlow()
    vm.onBackButtonTap = { [weak self] in
      self?.viewControllable.popViewController(animated: true)
    }
    self.viewControllable.pushViewController(vc, animated: true)
  }
}

// MARK: SignUp

extension AuthCoordinator {
  func runSignUPFlow(_ user: PendingUser) {
    let coordinator = signUpBuilder.build(rootViewControllable: self.viewControllable)
    coordinator.finishFlow = { [weak self, weak coordinator] option in
      switch option {
      case .complete:
        self?.finishFlow?()
        self?.detachChild(coordinator)
      case .back:
        self?.detachChild(coordinator)
      }
    }
    attachChild(coordinator)
    coordinator.start(user)
  }

  func detach() {
    self.childCoordinators.forEach { child in
      child.viewControllable.setViewControllers([])
      detachChild(child)
    }
  }
}
