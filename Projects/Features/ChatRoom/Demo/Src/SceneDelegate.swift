//
//  SceneDelegate.swift
//  ChatRoom
//
//  Created by Kanghos on 1/20/25.
//

import UIKit

import Core

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var launcher: LaunchCoordinating?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    let window = UIWindow(windowScene: windowScene)
//
////    let appCoordinator = AppRootBuilder().build()
//
//    self.launcher = appCoordinator
//    self.launcher?.launch(window: window)

    self.window = window
  }

  func sceneDidDisconnect(_ scene: UIScene) { }

  func sceneDidBecomeActive(_ scene: UIScene) { }

  func sceneWillResignActive(_ scene: UIScene) { }

  func sceneWillEnterForeground(_ scene: UIScene) { }

  func sceneDidEnterBackground(_ scene: UIScene) { }
}
