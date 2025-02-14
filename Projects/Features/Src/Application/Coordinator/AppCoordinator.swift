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
  private let signUpBuildable: SignUpBuildable

  init(
    viewControllable: ViewControllable,
    mainBuildable: MainBuildable,
    authBuildable: AuthBuildable,
    signUpBuildable: SignUpBuildable
  ) {
    self.mainBuildable = mainBuildable
    self.authBuildable = authBuildable
    self.signUpBuildable = signUpBuildable

    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    authFlow()
  }

  // MARK: - public
  func authFlow() {
    let coordinator = self.authBuildable.build(rootViewController: self.viewControllable)

    coordinator.finishFlow = { [weak self, weak coordinator] option in
      guard let coordinator else { return }
      switch option {
      case .toMain:
        self?.mainFlow()
      case let .toSignUp(user):
        self?.runSignUpFlow(user)
      }
      self?.detachChild(coordinator)
    }

    attachChild(coordinator)
    coordinator.start()
  }

  func runSignUpFlow(_ userInfo: SNSUserInfo) {
    let coordinator = self.signUpBuildable.build(rootViewControllable: self.viewControllable)

    coordinator.finishFlow = { [weak self, weak coordinator] option in
      guard let coordinator else { return }
      self?.detachChild(coordinator)
      switch option {
      case .complete:
        self?.mainFlow()
      case .back:
        break
      }
    }

    attachChild(coordinator)
    coordinator.start(userInfo)
  }

  func mainFlow() {
    let coordinator = mainBuildable.build()
    coordinator.finishFlow = { [weak self, weak coordinator] in
      guard let coordinator else { return }
      self?.authFlow()
      self?.detachChild(coordinator)
    }
    attachChild(coordinator)
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
