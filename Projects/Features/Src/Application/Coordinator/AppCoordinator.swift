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

protocol AppCoordinating {
  func launchFlow()
  func authFlow()
  func mainFlow()
}

final class AppCoordinator: LaunchCoordinator, AppCoordinating {

  private let mainBuildable: MainBuildable
  private let authBuildable: AuthBuildable
  private let launchBuildable: LaunchBuildable

  init(
    viewControllable: ViewControllable,
    mainBuildable: MainBuildable,
    authBuildable: AuthBuildable,
    launchBUidlable: LaunchBuildable
  ) {
    self.mainBuildable = mainBuildable
    self.authBuildable = authBuildable
    self.launchBuildable = launchBUidlable
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
    let coordinator = self.authBuildable.build()

    attachChild(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }

  func mainFlow() {
    let mainCoordinator = mainBuildable.build()

    attachChild(mainCoordinator)
    mainCoordinator.delegate = self

    mainCoordinator.start()
  }
}

extension AppCoordinator: MainCoordinatorDelegate {
  func detachTab(_ coordinator: Coordinator) {
    detachChild(coordinator)

    authFlow()
  }
}

extension AppCoordinator: AuthCoordinatingDelegate {
  func detachAuth(_ coordinator: Core.Coordinator) {
    detachChild(coordinator)

    mainFlow()
  }
}

extension AppCoordinator: LaunchCoordinatingDelegate {
  func finishFlow(_ coordinator: Core.Coordinator, _ action: AuthInterface.LaunchAction) {
    switch action {
    case .needAuth:
      authFlow()
    case .toMain:
      mainFlow()
    }
    detachChild(coordinator)
  }
}

extension AppCoordinator: URLHandling {
  func handle(_ url: URL) {
    if (AuthApi.isKakaoTalkLoginUrl(url)) {
      _ = AuthController.handleOpenUrl(url: url)

    }
  }
}
