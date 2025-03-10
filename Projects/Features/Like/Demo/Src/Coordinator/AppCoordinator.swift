//
//  AppCoordinator.swift
//  LikeDemo
//
//  Created by Kanghos on 2023/12/07.
//

import UIKit
import LikeInterface
import Core
import Domain

protocol AppCoordinating {
  func likeFlow()
}

final class AppCoordinator: LaunchCoordinator, AppCoordinating {
  private let likeBuildable: LikeBuildable
  private let talkUseCase: TalkUseCaseInterface = DefaultTalkUseCase()

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
    let rootViewControllable = NavigationViewControllable()
    replaceWindowRootViewController(rootViewController: rootViewControllable)
    
    let coordinator = self.likeBuildable.build(rootViewControllable: rootViewControllable, talkUseCase: talkUseCase)
    coordinator.finishFlow = { [weak self, weak coordinator] in
      guard let coordinator else { return }
      self?.detachChild(coordinator)
    }

    attachChild(coordinator)
    coordinator.start()
  }
}
