//
//  AppRootBuilder.swift
//  ChatRoom
//
//  Created by Kanghos on 1/20/25.
//

import UIKit

import DSKit

import ChatRoom
import ChatRoomInterface
import Domain
import Auth
import Data

public protocol AppRootBuildable {
  func build() -> LaunchCoordinating
}

public final class AppRootBuilder: AppRootBuildable {
  @Injected var talkUseCase: TalkUseCaseInterface
  public init() { }

  lazy var chatRoomBuilder: ChatRoomBuildable = {
    ChatRoomBuilder(talkUseCase: talkUseCase)
  }()

  public func build() -> LaunchCoordinating {

    let viewController = NavigationViewControllable(rootViewControllable: TFLaunchViewController())

    let coordinator = AppCoordinator(
      viewControllable: viewController,
      chatRoomBuildable: self.chatRoomBuilder
    )
    return coordinator
  }
}

