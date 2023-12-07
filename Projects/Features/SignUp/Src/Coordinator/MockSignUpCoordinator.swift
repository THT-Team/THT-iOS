//
//  SignUpCoordinator.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core
import SignUpInterface

public final class MockSignUpCoordinator: BaseCoordinator, SignUpCoordinating {
  public weak var delegate: SignUpCoordinatorDelegate?
  
  // TODO: UserDefaultStorage이용해서 어느 화면 띄워줄건지 결정
  public override func start() {
    authFlow()
  }
  
  public func authFlow() {
    let viewModel = MockSignUpViewModel()
    viewModel.delegate = self
    let viewController = MockSignUpViewController()
    viewController.viewModel = viewModel

    self.viewControllable.setViewControllers([viewController])
  }
  
  public func finishFlow() {
    self.delegate?.detachSignUp(self)
  }
  
  public func emailFlow() {
    
  }
  
  public func nicknameFlow() {
    
  }
}

extension MockSignUpCoordinator: SignUpHomeDelegate {
  func signUpSuccess() {
    self.delegate?.detachSignUp(self)
  }
}
