//
//  LaunchRouter.swift
//  App
//
//  Created by Kanghos on 2023/11/30.
//

import UIKit

public protocol LaunchCoordinating {
  func launch(window: UIWindow)
}

public protocol URLHandling {
  func handle(_ url: URL)
}

open class LaunchCoordinator: BaseCoordinator, LaunchCoordinating {

  public func launch(window: UIWindow) {
    window.rootViewController = self.viewControllable.uiController
    window.makeKeyAndVisible()

    TFLogger.domain.debug("AppCoordinator 1초 async")
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.start()
    }
  }
}

