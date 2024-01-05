//
//  MainBuilder.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit
import Core

import LikeInterface
import Like

final class MainBuilder: MainBuildable {
  func build() -> MainCoordinating {
    let tabBar = TFTabBarController()
    let likeBuilder = LikeBuilder()

    let coordinator = MainCoordinator(
      viewControllable: tabBar,
      likeBuildable: likeBuilder)

    return coordinator
  }
}
