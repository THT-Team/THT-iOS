//
//  NavigationViewControllable.swift
//  DSKit
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

public final class NavigationViewControllable: ViewControllable {
  public var uiController: UIViewController { self.navigationController }
  public let navigationController: UINavigationController

  public init(rootViewControllable: ViewControllable) {
    let navigationController = UINavigationController(rootViewController: rootViewControllable.uiController )

    self.navigationController = navigationController
  }

  public init() {
    let navigationController = UINavigationController()
    self.navigationController = navigationController
  }
}
