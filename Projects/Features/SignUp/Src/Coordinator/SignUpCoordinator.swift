//
//  SignUpCoordinator.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core
import SignUpInterface

public final class SignUpCoordinator: BaseCoordinator, SignUpCoordinating {
  public weak var delegate: SignUpCoordinatorDelegate?
  
  // TODO: UserDefaultStorage이용해서 어느 화면 띄워줄건지 결정
  public override func start() {
    rootFlow()
  }
  
  public func rootFlow() {
    let viewModel = SignUpRootViewModel()
    viewModel.delegate = self

    let viewController = SignUpRootViewController()
    viewController.viewModel = viewModel

    self.viewControllable.setViewControllers([viewController])
  }
  
  public func finishFlow() {
    self.delegate?.detachSignUp(self)
  }
  
  public func emailFlow() {
    let viewModel = EmailInputViewModel()
    viewModel.delegate = self

    let viewController = EmailInputViewController(viewModel: viewModel)

    self.viewControllable.pushViewController(viewController, animated: true)
  }
  
  public func nicknameFlow() {
    let viewModel = NicknameInputViewModel()
    viewModel.delegate = self

    let viewController = NicknameInputViewController(viewModel: viewModel)
    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func policyFlow() {
    let viewModel = PolicyAgreementViewModel()
    viewModel.delegate = self

    let viewController = PolicyAgreementViewController(viewModel: viewModel)

    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func phoneNumberFlow() {
    let viewModel = PhoneCertificationViewModel()
    viewModel.delegate = self

    let viewController = PhoneCertificationViewController(viewModel: viewModel)

    self.viewControllable.pushViewController(viewController, animated: true)
  }
}

extension SignUpCoordinator: SignUpRootDelegate {
  func toPhoneButtonTap() {
    phoneNumberFlow()
  }
}

extension SignUpCoordinator: PhoneCertificationDelegate {
  func finishAuth() {
    emailFlow()
  }
}

extension SignUpCoordinator: EmailInputDelegate {
  func emailNextButtonTap() {
    policyFlow()
  }
}

extension SignUpCoordinator: PolicyAgreementDelegate {
  func policyNextButtonTap() {
    nicknameFlow()
  }
}

extension SignUpCoordinator: NicknameInputDelegate {
  func nicknameNextButtonTap() {
    
  }
}
