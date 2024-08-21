//
//  AppCoordinator.swift
//  LikeDemo
//
//  Created by Kanghos on 2023/12/07.
//

import UIKit

import Core
import MyPageInterface

protocol AppCoordinating {
  func myPageFlow()
}

final class AppCoordinator: LaunchCoordinator, AppCoordinating {

  private let myPageBuildable: MyPageBuildable

  init(
    viewControllable: ViewControllable,
    myPageBuildable: MyPageBuildable
  ) {
    self.myPageBuildable = myPageBuildable
    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    myPageFlow()
  }

  // MARK: - public
  func myPageFlow() {
    let myPageCoordinator = self.myPageBuildable.build()

    attachChild(myPageCoordinator)
    myPageCoordinator.delegate = self

    myPageCoordinator.start()
  }
}

extension AppCoordinator: MyPageCoordinatorDelegate {
  func detachMyPage(_ coordinator: Core.Coordinator) {
    detachChild(coordinator)

    TFLogger.dataLogger.debug("test")
  }
}
