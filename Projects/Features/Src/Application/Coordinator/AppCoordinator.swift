//
//  AppCoordinator.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit
import Combine

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
  private var cancellables = Set<AnyCancellable>()

  init(
    viewControllable: ViewControllable,
    mainBuildable: MainBuildable,
    authBuildable: AuthBuildable
  ) {
    self.mainBuildable = mainBuildable
    self.authBuildable = authBuildable

    super.init(viewControllable: viewControllable)

    bind()
  }

  public override func start() {
    authFlow()
  }

  // MARK: - public
  func authFlow() {
    let coordinator = self.authBuildable.build()
    attachChild(coordinator)

    coordinator.finishFlow = { [weak self, weak coordinator] in
      self?.mainFlow()
      self?.detachChild(coordinator)
    }
    coordinator.start()
  }

  func mainFlow() {
    let coordinator = mainBuildable.build()
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

  func bind() {
    NotificationCenter.default.publisher(for: .needAuthLogout)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.childCoordinators.removeAll()
        self?.authFlow()
      }
      .store(in: &cancellables)
  }
}
