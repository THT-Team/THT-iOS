//
//  AppRootBuilder.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

import Core
import DSKit

import Falling
import FallingInterface
import ChatRoomInterface
import ChatRoom
import Domain

public protocol AppRootBuildable {
  func build() -> LaunchCoordinating
}

public final class AppRootBuilder: AppRootBuildable {
  public init() { }

  lazy var fallingBuildable: FallingBuildable = {
    FallingBuilder(chatRoomBuilder: ChatRoomBuilder(talkUseCase: MockTalkUseCase()))
  }()

  public func build() -> LaunchCoordinating {

    let viewController = NavigationViewControllable(rootViewControllable: TFLaunchViewController())

    let coordinator = AppCoordinator(
      viewControllable: viewController,
      fallingBuildable: self.fallingBuildable
    )
    return coordinator
  }
}

