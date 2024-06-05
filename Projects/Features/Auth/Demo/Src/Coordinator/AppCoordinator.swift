//
//  AppCoordinator.swift
//  AuthDemo
//
//  Created by Kanghos on 6/3/24.
//

import UIKit
import SignUpInterface
import AuthInterface
import Core
import DSKit

protocol AppCoordinating {
  func authFlow()
}

final class AppCoordinator: LaunchCoordinator, AppCoordinating {

  private let authBuildable: AuthBuildable
  private let launchBuildable: LaunchBuildable

  init(
    viewControllable: ViewControllable,
    authBuildable: AuthBuildable,
    launchBuildable: LaunchBuildable
  ) {
    self.authBuildable = authBuildable
    self.launchBuildable = launchBuildable
    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    launchFlow()
  }

  func launchFlow() {
    let coordinator = self.launchBuildable.build(rootViewControllable: self.viewControllable)
    attachChild(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }

  // MARK: - public
  func authFlow() {
    let authCoordinator = self.authBuildable.build()

    attachChild(authCoordinator)
    authCoordinator.delegate = self
    authCoordinator.start()
  }

  class MainViewController: TFBaseViewController {
    override func viewDidLoad() {
      super.viewDidLoad()

      let label = UILabel()
      label.center = self.view.center
      label.text = "Main"
      label.textColor = DSKitAsset.Color.neutral50.color
      self.view.backgroundColor = .yellow
      self.view.addSubview(label)
    }
  }

  func mainFlow() {
    replaceWindowRootViewController(rootViewController: viewControllable)
    let vc = MainViewController()

    self.viewControllable.setViewControllers([vc])
  }
}

extension AppCoordinator: AuthCoordinatingDelegate {
  func detachAuth(_ coordinator: Core.Coordinator) {
    detachChild(coordinator)
    mainFlow()
  }
}

extension AppCoordinator: LaunchCoordinatingDelegate {
  func finishFlow(_ coordinator: Coordinator, _ action: LaunchAction) {
    detachChild(coordinator)
    switch action {
    case .needAuth:
      authFlow()
    case .toMain:
      mainFlow()
    }
  }
}
