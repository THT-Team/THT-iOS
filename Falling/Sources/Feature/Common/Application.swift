//
//  Application.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/29.
//

import UIKit

final class Application {
	static let shared = Application()
	
	func configurationMainInterface(window: UIWindow?) {
		let signUpController = UINavigationController()
		let signUpNavigator = SignUpNavigator(controller: signUpController)

    guard let _ = AppData.accessToken else {
      window?.rootViewController = signUpController
      signUpNavigator.toRootView()
      return
    }
    window?.rootViewController = makeTabBarController()
	}
	
	private init() { }

  func makeTabBarController() -> UIViewController {
    let fallingNavigationController = UINavigationController()

    fallingNavigationController.tabBarItem = UITabBarItem(
      title: "폴링",
      image: FallingAsset.Image.falling.image.withRenderingMode(.alwaysOriginal),
      selectedImage: FallingAsset.Image.fallingSelected.image.withRenderingMode(.alwaysOriginal)
    )
    fallingNavigationController.tabBarItem.imageInsets = .init(top: 5, left: 0, bottom: -5, right: 0)

    let heartNavigationController = UINavigationController()
    //
    heartNavigationController.tabBarItem = UITabBarItem(
      title: "하트",
      image: FallingAsset.Image.heart.image.withRenderingMode(.alwaysOriginal),
      selectedImage: FallingAsset.Image.heartSelected.image.withRenderingMode(.alwaysOriginal)
    )
    heartNavigationController.tabBarItem.imageInsets = .init(top: 5, left: 0, bottom: -5, right: 0)

    let chatNavigationController = UINavigationController()
    let chatNavigator = ChatNavigator(controller: chatNavigationController)
    chatNavigationController.tabBarItem = UITabBarItem(
      title: "채팅",
      image: FallingAsset.Image.chat.image.withRenderingMode(.alwaysOriginal),
      selectedImage: FallingAsset.Image.chatSelected.image.withRenderingMode(.alwaysOriginal)
    )
    chatNavigationController.tabBarItem.imageInsets = .init(top: 5, left: 0, bottom: -5, right: 0)

    let myPageNavigationController = UINavigationController()
//
    myPageNavigationController.tabBarItem = UITabBarItem(
      title: "마이",
      image: FallingAsset.Image.more.image.withRenderingMode(.alwaysOriginal),
      selectedImage: FallingAsset.Image.moreSelected.image.withRenderingMode(.alwaysOriginal)
    )
    myPageNavigationController.tabBarItem.imageInsets = .init(top: 5, left: 0, bottom: -5, right: 0)

    let dependency = TabBarComponent()
    let tabBarController = TFTabBarController(dependency: dependency)

    tabBarController.viewControllers = [
      fallingNavigationController,
      heartNavigationController,
      chatNavigationController,
      myPageNavigationController
    ]
    chatNavigator.toList()

    return tabBarController
  }
}
