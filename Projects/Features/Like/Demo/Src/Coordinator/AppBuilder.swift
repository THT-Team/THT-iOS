//
//  AppRootBuilder.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

import DSKit

import Like
import LikeInterface
import ChatRoom

public protocol AppRootBuildable {
  func build() -> LaunchCoordinating
}

public final class AppRootBuilder: AppRootBuildable {
  public init() { }

  lazy var likeBuildable: LikeBuildable = {
    LikeBuilder(chatRoomBuilder: ChatRoomBuilder())
  }()

  public func build() -> LaunchCoordinating {

    let viewController = NavigationViewControllable(rootViewControllable: TFLaunchViewController())

    let coordinator = AppCoordinator(
      viewControllable: viewController,
      likeBuildable: self.likeBuildable
    )
    return coordinator
  }
}

