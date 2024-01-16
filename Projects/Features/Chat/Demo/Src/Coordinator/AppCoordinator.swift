//
//  AppCoordinator.swift
//  ChatDemo
//
//  Created by Kanghos on 2023/12/07.
//

import UIKit

import Core
import ChatInterface

protocol AppCoordinating {
  func chatFlow()
}

final class AppCoordinator: LaunchCoordinator, AppCoordinating {

  private let chatBuildable: ChatBuildable

  init(
    viewControllable: ViewControllable,
    chatBuildable: ChatBuildable
  ) {
    self.chatBuildable = chatBuildable
    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    chatFlow()
  }

  // MARK: - public
  func chatFlow() {
    let chatCoordinator = self.chatBuildable.build(rootViewControllable: self.viewControllable)

    attachChild(chatCoordinator)
    chatCoordinator.delegate = self

    chatCoordinator.start()
  }
}

extension AppCoordinator: ChatCoordinatorDelegate {
  func test(_ coordinator: Core.Coordinator) {
    detachChild(coordinator)

    TFLogger.dataLogger.debug("test")
  }
}
