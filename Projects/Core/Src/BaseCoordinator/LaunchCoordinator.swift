//
//  LaunchRouter.swift
//  App
//
//  Created by Kanghos on 2023/11/30.
//

import UIKit

public protocol URLHandling {
  func handle(_ url: URL)
}

public protocol LaunchCoordinating: Coordinator {
  func launch(window: UIWindow)
}


open class LaunchCoordinator: BaseCoordinator, LaunchCoordinating {

  public func launch(window: UIWindow) {
    window.rootViewController = self.viewControllable.uiController
    window.makeKeyAndVisible()

    self.start()
  }
}
