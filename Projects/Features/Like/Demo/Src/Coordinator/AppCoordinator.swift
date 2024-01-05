//
//  AppCoordinator.swift
//  LikeDemo
//
//  Created by Kanghos on 2023/12/07.
//

import UIKit
import LikeInterface
import Core

protocol AppCoordinating {
  func likeFlow()
}

final class AppCoordinator: LaunchCoordinator, AppCoordinating {

  private let likeBuildable: LikeBuildable

  init(
    viewControllable: ViewControllable,
    likeBuildable: LikeBuildable
  ) {
    self.likeBuildable = likeBuildable
    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    likeFlow()
  }

  // MARK: - public
  func likeFlow() {
    let likeCoordinator = self.likeBuildable.build(rootViewControllable: self.viewControllable)

    attachChild(likeCoordinator)
    likeCoordinator.delegate = self

    likeCoordinator.start()
  }
}

extension AppCoordinator: LikeCoordinatorDelegate {
  func test(_ coordinator: Core.Coordinator) {
    detachChild(coordinator)

    TFLogger.dataLogger.debug("test")
  }
}
