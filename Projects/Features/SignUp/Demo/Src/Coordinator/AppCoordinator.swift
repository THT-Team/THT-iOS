//
//  AppCoordinator.swift
//  LikeDemo
//
//  Created by Kanghos on 2023/12/07.
//

import UIKit
import SignUpInterface
import Core

protocol AppCoordinating {
  func signUpFlow()
}

final class AppCoordinator: LaunchCoordinator, AppCoordinating {

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

  // MARK: - public
  func signUpFlow() {
    let signUpCoordinator = self.signUpBuildable.build(rootViewController: self.viewControllable)

    attachChild(signUpCoordinator)
    signUpCoordinator.delegate = self

    signUpCoordinator.start()
  }
}

extension AppCoordinator: SignUpCoordinatorDelegate {
  func detachSignUp(_ coordinator: Core.Coordinator) {
    self.viewControllable.setViewControllers([])
    detachChild(coordinator)
  }
}
