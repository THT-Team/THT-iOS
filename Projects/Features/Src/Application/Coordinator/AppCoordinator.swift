//
//  AppCoordinator.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit
import Foundation

import Core
import SignUpInterface
import DSKit

protocol AppCoordinating {
  func signUpFlow()
  func mainFlow()
}

final class AppCoordinator: LaunchCoordinator, AppCoordinating {

  private let mainBuildable: MainBuildable
  private let signUpBuildable: SignUpBuildable

  init(
    viewControllable: ViewControllable,
    mainBuildable: MainBuildable,
    signUpBuildable: SignUpBuildable
  ) {
    self.mainBuildable = mainBuildable
    self.signUpBuildable = signUpBuildable
    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.selectFlow()
    }
  }

  // MARK: - public
  func signUpFlow() {
    let signUpCoordinator = self.signUpBuildable.build()

    attachChild(signUpCoordinator)
    signUpCoordinator.delegate = self

    signUpCoordinator.start()
  }

  func mainFlow() {
    let mainCoordinator = mainBuildable.build()

    attachChild(mainCoordinator)
    mainCoordinator.delegate = self

    mainCoordinator.start()
  }

  // MARK: - Private
  private func selectFlow() {
    mainFlow()
  }
}

extension AppCoordinator: MainCoordinatorDelegate {
  func detachTab(_ coordinator: Coordinator) {
    detachChild(coordinator)

    signUpFlow()
  }
}

extension AppCoordinator: SignUpCoordinatorDelegate {
  
  func detachSignUp(_ coordinator: Coordinator) {
    detachChild(coordinator)
    
    mainFlow()
  }
}
