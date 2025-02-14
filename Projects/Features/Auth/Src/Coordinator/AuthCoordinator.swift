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

  @Injected private var authUseCase: AuthUseCaseInterface

  // MARK: Signal
  public var phoneNumberVerified: ((String) -> Void)?

  public var finishFlow: ((AuthCoordinatorOutput) -> Void)?

  public let factory: PhoneNumberFactoryType

  public init(
    factory: PhoneNumberFactoryType = PhoneNumberFactory(),
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
    let vm = LauncherViewModel(useCase: self.authUseCase)
    let vc = TFAuthLauncherViewController(viewModel: vm)

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

    let viewModel = AuthRootViewModel(useCase: authUseCase)

    let viewController = AuthRootViewController()
    viewController.viewModel = viewModel

    viewModel.onPhoneNumberAuthFlow = {
      self.phoneNumberInputFlow()
    }

    viewModel.onSignUpFlow = { [weak self] userInfo in
      self?.viewControllable.popViewController(animated: true)
      self?.finishFlow?(.toSignUp(userInfo))
    }

    viewModel.onMainFlow = { [weak self] in
      self?.viewControllable.popToRootViewController(animated: true)
      self?.finishFlow?(.toMain)
    }

    viewModel.onInquiryFlow = {
      self.inquiryFlow()
    }

    self.phoneNumberVerified = { [weak viewModel] phoneNumber in
      viewModel?.onPhoneNumberVerified(phoneNumber)
    }

    self.viewControllable.setViewControllers([viewController])
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
    let vm = InquiryViewModel()
    vm.onBackButtonTap = {
      self.viewControllable.popViewController(animated: true)
    }
    let vc = InquiryViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }
}
