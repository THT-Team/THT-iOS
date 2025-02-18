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
import AuthInterface
import Auth
import KakaoSDKAuth
import KakaoSDKUser
import DSKit
import Domain

protocol AppCoordinating {
  func authFlow()
  func mainFlow()
}

final class AppCoordinator: LaunchCoordinator, AppCoordinating {
  private let mainBuildable: MainBuildable
  private let authBuildable: AuthBuildable

  init(
    viewControllable: ViewControllable,
    mainBuildable: MainBuildable,
    authBuildable: AuthBuildable
  ) {
    self.mainBuildable = mainBuildable
    self.authBuildable = authBuildable

    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    authFlow()
  }

  // MARK: - public
  func authFlow() {
    let coordinator = self.authBuildable.build(ProgressNavigationViewControllable())
    attachChild(coordinator)

    coordinator.finishFlow = { [weak self, weak coordinator] in
      self?.mainFlow()
      self?.detachChild(coordinator)
    }
    coordinator.start()
  }

  func mainFlow() {
    let coordinator = mainBuildable.build(TFTabBarController())
    attachChild(coordinator)

    coordinator.finishFlow = { [weak self, weak coordinator] in
      self?.authFlow()
      self?.detachChild(coordinator)
    }
    coordinator.start()
  }
}

extension AppCoordinator: URLHandling {
  func handle(_ url: URL) {
    if (AuthApi.isKakaoTalkLoginUrl(url)) {
      _ = AuthController.handleOpenUrl(url: url)

    }
  }
}
