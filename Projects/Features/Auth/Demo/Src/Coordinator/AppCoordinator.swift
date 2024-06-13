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
    override func makeUI() {
      let button = UIButton()
      button.setTitle("가입내역 지우기", for: .normal)
      button.backgroundColor = DSKitAsset.Color.primary500.color
      self.view.addSubview(button)
      button.addAction(UIAction {_ in 
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
      }, for: .touchUpInside)
      button.layer.cornerRadius = 16
      button.clipsToBounds = true

      button.snp.makeConstraints {
        $0.center.equalToSuperview()
        $0.height.equalTo(60)
        $0.width.equalToSuperview().inset(80)
      }
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
