//
//  AppCoordinator.swift
//  LikeDemo
//
//  Created by Kanghos on 2023/12/07.
//

import UIKit
import SignUpInterface
import Core
import DSKit

final class AppCoordinator: LaunchCoordinator {

  private let signUpBuildable: SignUpBuildable

  init(
    viewControllable: ViewControllable,
    signUpBuildable: SignUpBuildable
  ) {
    self.signUpBuildable = signUpBuildable
    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    signUpFlow()
  }

  func signUpFlow() {
    let signUpCoordinator = self.signUpBuildable.build(phoneNumber: "01089192466")

    attachChild(signUpCoordinator)
    signUpCoordinator.delegate = self

    signUpCoordinator.start()
  }
}

extension AppCoordinator: SignUpCoordinatorDelegate {
  func detachSignUp(_ coordinator: Core.Coordinator) {
    detachChild(coordinator)
  }
}
