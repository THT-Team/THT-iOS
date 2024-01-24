//
//  AppCoordinator.swift
//  LikeDemo
//
//  Created by Kanghos on 2023/12/07.
//

import UIKit

import Core
import FallingInterface

protocol AppCoordinating {
  func fallingFlow()
}

final class AppCoordinator: LaunchCoordinator, AppCoordinating {
  
  private let fallingBuildable: FallingBuildable
  
  init(
    viewControllable: ViewControllable,
    fallingBuildable: FallingBuildable
  ) {
    self.fallingBuildable = fallingBuildable
    super.init(viewControllable: viewControllable)
  }
  
  public override func start() {
    fallingFlow()
  }
  
  // MARK: - public
  func fallingFlow() {
    let rootViewControllable = NavigationViewControllable()
    replaceWindowRootViewController(rootViewController: rootViewControllable)
    
    let fallingCoordinator = self.fallingBuildable.build(rootViewControllable: rootViewControllable)
    
    attachChild(fallingCoordinator)
    fallingCoordinator.delegate = self
    
    fallingCoordinator.start()
  }
}

extension AppCoordinator: FallingCoordinatorDelegate {
  func test(_ coordinator: Core.Coordinator) {
    detachChild(coordinator)
    
    TFLogger.dataLogger.debug("test")
  }
}
