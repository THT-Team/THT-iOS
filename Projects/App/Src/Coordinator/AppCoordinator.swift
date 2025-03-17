//
//  AppCoordinator.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation
import UIKit
import Domain
import Combine
import Feature

protocol AppCoordinating {
  func authFlow()
  func mainFlow()
}

final class AppCoordinator: LaunchCoordinator, AppCoordinating {
  private let mainBuildable: MainBuildable
  private let authBuildable: AuthBuildable
  @Injected var useCase: AuthUseCaseInterface
  private var cancellables = Set<AnyCancellable>()
  private let notificationHandler = NotificationHandler()

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
    launchFlow()
  }

  public func launchFlow() {
    let vm = LauncherViewModel()
    let vc = TFAuthLauncherViewController(viewModel: vm)
    self.viewControllable = vc
    replaceWindowRootViewController(rootViewController: self.viewControllable)

    vm.onAuthResult = { [weak self] result in
      switch result {
      case .needAuth:
        self?.authFlow()
      case .toMain:
        self?.mainFlow()
      }
    }
  }

  // MARK: - public
  func authFlow() {
    let coordinator = self.authBuildable.build()
    self.viewControllable.present(coordinator.viewControllable, animated: true)
    attachChild(coordinator)

    coordinator.finishFlow = { [weak self, weak coordinator] in
      self?.viewControllable.dismiss()
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
    
  }

  func bind() {
    NotificationCenter.default.publisher(for: .needAuthLogout)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.childCoordinators.removeAll()
        UserDefaultRepository.shared.removeUser()
        self?.notificationHandler.unregisterRemoteNotifications()
        self?.authFlow()
      }
      .store(in: &cancellables)

    NotificationCenter.default.publisher(for: .requestPushNotification)
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        guard let self else { return }
        self.notificationHandler.registerForRemoteNotifications()
        self.notificationHandler.registerFirebaseMessaging()
      }
      .store(in: &cancellables)
  }
}
