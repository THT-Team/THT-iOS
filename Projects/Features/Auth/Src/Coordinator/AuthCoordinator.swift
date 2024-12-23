//
//  AuthCoordinator.swift
//  AuthInterface
//
//  Created by Kanghos on 5/8/24.
//

import Foundation

import Core
import AuthInterface

public final class AuthCoordinator: BaseCoordinator, AuthCoordinating {

  @Injected private var authUseCase: AuthUseCaseInterface

  // MARK: Signal
  public var phoneNumberVerified: ((String) -> Void)?

  public var finishFlow: (() -> Void)?
  public var signUpFlow: ((SNSUserInfo) -> Void)?

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

    rootFlow()
  }

  // MARK: 인증 토큰 재발급 또는 가입 시
  public func rootFlow() {
    let viewModel = AuthRootViewModel(useCase: authUseCase)

    let viewController = AuthRootViewController()
    viewController.viewModel = viewModel

    viewModel.onPhoneNumberAuthFlow = { [weak self] in
      self?.phoneNumberInputFlow()
    }

    viewModel.onSignUpFlow = { [weak self] userInfo in
      self?.signUpFlow?(userInfo)
    }

    viewModel.onMainFlow = { [weak self] in
      guard let self else { return }
      self.viewControllable.popViewController(animated: true)
      self.finishFlow?()
    }

    viewModel.onInquiryFlow = { [weak self] in
      guard let self else { return }
      self.inquiryFlow()
    }

    self.phoneNumberVerified = { [weak viewModel] phoneNumber in
      viewModel?.onPhoneNumberVerified?(phoneNumber)
    }

    self.viewControllable.setViewControllers([viewController])
  }
}

extension AuthCoordinator {
  func inquiryFlow() {
    let vm = InquiryViewModel()
    vm.onBackButtonTap = { [weak self] in
      self?.viewControllable.popViewController(animated: true)
    }
    let vc = InquiryViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
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
