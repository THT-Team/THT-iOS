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
  func launchFlow()
  func authFlow()
  func mainFlow()
}

final class AppCoordinator: LaunchCoordinator, AppCoordinating {

  private let mainBuildable: MainBuildable
  private let authBuildable: AuthBuildable
  private let launchBuildable: LaunchBuildable
  private let signUpBuildable: SignUpBuildable
  private let talkUseCase: TalkUseCaseInterface

  init(
    viewControllable: ViewControllable,
    mainBuildable: MainBuildable,
    authBuildable: AuthBuildable,
    launchBUidlable: LaunchBuildable,
    signUpBuildable: SignUpBuildable,
    talkUseCase: TalkUseCaseInterface
  ) {
    self.mainBuildable = mainBuildable
    self.authBuildable = authBuildable
    self.launchBuildable = launchBUidlable
    self.signUpBuildable = signUpBuildable
    self.talkUseCase = talkUseCase
    // FIXME: talkUseCase를 메인 진입 후 하는 게 나을 것 같은데 어디서 초기화를 해야할지..?

    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    launchFlow()
  }

  func launchFlow() {
    let coordinator = self.launchBuildable.build(rootViewControllable: self.viewControllable)

    coordinator.finishFlow = { [weak self, weak coordinator] action in
      guard let coordinator else { return }
      switch action {
      case .needAuth:
        self?.authFlow()
      case .toMain:
        self?.mainFlow()
      }
      self?.detachChild(coordinator)
    }
    attachChild(coordinator)
    coordinator.start()
  }

  // MARK: - public
  func authFlow() {
    let coordinator = self.authBuildable.build(rootViewController: self.viewControllable)

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
      self?.mainFlow()
    }

    attachChild(coordinator)
    coordinator.start(userInfo)
  }

  func mainFlow() {
    let coordinator = mainBuildable.build(talkUseCase: self.talkUseCase)
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
