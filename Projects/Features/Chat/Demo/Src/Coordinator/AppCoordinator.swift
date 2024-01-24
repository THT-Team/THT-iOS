//
//  AppCoordinator.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/14.
//

import UIKit
import ChatInterface
import Core

protocol AppCoordinating {
  func chatFlow()
}

final class AppCoordinator: LaunchCoordinator, AppCoordinating {
  private let mainBuildable: ChatBuildable

  init(
    viewControllable: ViewControllable,
    chatBuildable: ChatBuildable
  ) {
    self.mainBuildable = chatBuildable
    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    chatFlow()
  }
  
  // MARK: - public
  func chatFlow() {
    let rootViewControllable = NavigationViewControllable()
    replaceWindowRootViewController(rootViewController: rootViewControllable)

    let chatCoordinator = self.mainBuildable.build(rootViewControllable: rootViewControllable)

    attachChild(chatCoordinator)
    chatCoordinator.delegate = self

    chatCoordinator.start()
  }
}

extension AppCoordinator: ChatCoordinatorDelegate {
  
}
