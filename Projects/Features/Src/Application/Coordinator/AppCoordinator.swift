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
  private let signUpBuildable: SignUpBuildable

  init(
    viewControllable: ViewControllable,
    mainBuildable: MainBuildable,
    authBuildable: AuthBuildable,
    launchBUidlable: LaunchBuildable,
    signUpBuildable: SignUpBuildable
  ) {
    self.mainBuildable = mainBuildable
    self.authBuildable = authBuildable
    self.launchBuildable = launchBUidlable
    self.signUpBuildable = signUpBuildable
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

    coordinator.finishFlow = { [weak self, weak coordinator] in
      guard let coordinator else { return }
      self?.detachChild(coordinator)
      self?.mainFlow()
    }

    coordinator.signUpFlow = { [weak self] userInfo in
      self?.runSignUpFlow(userInfo)
    }

    attachChild(coordinator)
    coordinator.start()
  }

  func runSignUpFlow(_ userInfo: SNSUserInfo) {
    let coordinator = self.signUpBuildable.build(rootViewControllable: self.viewControllable)

    coordinator.finishFlow = { [weak self, weak coordinator] in
      guard let coordinator else { return }
      self?.detachChild(coordinator)
      self?.start()
    }

    attachChild(coordinator)
    coordinator.start(userInfo)
  }

  func mainFlow() {
    let coordinator = mainBuildable.build()
    coordinator.finishFlow = { [weak self, weak coordinator] in
      guard let coordinator else { return }
      self?.detachChild(coordinator)
      self?.authFlow()
    }
    attachChild(coordinator)
    coordinator.start()
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
