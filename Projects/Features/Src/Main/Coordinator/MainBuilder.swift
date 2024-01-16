//
//  MainBuilder.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit
import Core

import FallingInterface
import Falling

import LikeInterface
import Like

import ChatInterface
import Chat

import MyPageInterface
import MyPage

final class MainBuilder: MainBuildable {
  func build() -> MainCoordinating {
    let tabBar = TFTabBarController()
    let fallingBuilder = FallingBuilder()
    let likeBuilder = LikeBuilder()
    let chatBuilder = ChatBuilder()
    let myPageBuilder = MyPageBuilder()

    let coordinator = MainCoordinator(
      viewControllable: tabBar,
      fallingBuildable: fallingBuilder,
      likeBuildable: likeBuilder,
      chatBuildable: chatBuilder,
      myPageBuildable: myPageBuilder
    )

    return coordinator
  }
}
