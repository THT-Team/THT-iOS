//
//  ViewControllable.swift
//  Core
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

public protocol ViewControllable {
  var uiController: UIViewController { get }
}

public extension ViewControllable where Self: UIViewController {
  var uiController: UIViewController { self }
}

public extension ViewControllable {
  func setViewControllers(_ viewControllerables: [ViewControllable]) {
    if let nav = self.uiController as? UINavigationController {
      nav.setViewControllers(viewControllerables.map(\.uiController), animated: true)
    } else {
      self.uiController.navigationController?.setViewControllers(viewControllerables.map(\.uiController), animated: true)
    }
  }
}
