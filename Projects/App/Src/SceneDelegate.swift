//
//  SceneDelegate.swift
//  App
//
//  Created by Hoo's MacBookPro on 12/3/23.
//

import UIKit

import Feature
import Core

final class AppComponent: AppRootDependency {
  public init() { }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var launcher: LaunchCoordinating?
  var linkHandler: URLHandling?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    let window = UIWindow(windowScene: windowScene)
    let appCoordinator = AppRootBuilder(dependency: AppComponent()).build()
    self.launcher = appCoordinator
    self.linkHandler = appCoordinator
    self.launcher?.launch(window: window)

    self.window = window
  }

  func sceneDidDisconnect(_ scene: UIScene) { }

  func sceneDidBecomeActive(_ scene: UIScene) { }

  func sceneWillResignActive(_ scene: UIScene) { }

  func sceneWillEnterForeground(_ scene: UIScene) { }

  func sceneDidEnterBackground(_ scene: UIScene) { }
}

extension SceneDelegate {
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else { return }
    self.linkHandler?.handle(url)
  }
}
