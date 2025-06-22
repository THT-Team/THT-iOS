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

  public init() { }
  @Injected var talkUseCase: TalkUseCaseInterface
  @Injected var chatUseCase: ChatUseCaseInterface
  @Injected var userUseCase: UserDomainUseCaseInterface

  lazy var chatRoomBuilder: ChatRoomBuildable = {
    ChatRoomBuilder(ChatRoomFactory(talkUseCase: talkUseCase, userUseCase: userUseCase, chatUseCase: chatUseCase))
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

