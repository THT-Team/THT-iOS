//
//  AppBuilder.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/14.
//

import UIKit

import Core
import DSKit

import Chat
import ChatInterface

public protocol AppRootBuildable {
  func build() -> LaunchCoordinating
}

public final class AppRootBuilder: AppRootBuildable {
  public init() { }

  lazy var chatBuildable: ChatBuildable = {
    ChatBuilder()
  }()

  public func build() -> LaunchCoordinating {

    let viewController = TFLaunchViewController()

    let coordinator = AppCoordinator(
      viewControllable: viewController,
      chatBuildable: self.chatBuildable
    )
    return coordinator
  }
}

