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

import AuthInterface

final class MainComponent: MyPageDependency {
  var inquiryBuildable: AuthInterface.InquiryBuildable { dependency.inquiryBuildable }

  var authViewFactory: AuthInterface.AuthViewFactoryType { dependency.authViewFactory }

  private let dependency: MyPageDependency

  init(dependency: MyPageDependency) {
    self.dependency = dependency
  }
}

final class MainBuilder: MainBuildable {
  private let dependency: MyPageDependency

  init(dependency: MyPageDependency) {
    self.dependency = dependency
  }

  func build() -> MainCoordinating {
    let tabBar = TFTabBarController()
    let fallingBuilder = FallingBuilder()
    let likeBuilder = LikeBuilder()
    let chatBuilder = ChatBuilder()
    let myPageBuilder = MyPageBuilder(dependency: dependency)

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
