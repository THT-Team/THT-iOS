//
//  ViewControllable.swift
//  Core
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

public protocol ViewControllable: AnyObject {
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

  func pushViewController(_ viewControllable: ViewControllable, animated: Bool) {
    if let nav = self.uiController as? UINavigationController {
      nav.pushViewController(viewControllable.uiController, animated: animated)
    } else {
      self.uiController.navigationController?.pushViewController(viewControllable.uiController, animated: animated)
    }
  }

  func popViewController(animated: Bool) {
    if let nav = self.uiController as? UINavigationController {
      nav.popViewController(animated: animated)
    } else {
      self.uiController.navigationController?.popViewController(animated: animated)
    }
  }

  func popToRootViewController(animated: Bool) {
    if let nav = self.uiController as? UINavigationController {
      nav.popToRootViewController(animated: animated)
    } else {
      self.uiController.navigationController?.popToRootViewController(animated: animated)
    }
  }

  func present(_ viewControllable: ViewControllable, animated: Bool) {
    if let nav = self.uiController as? UINavigationController {
      nav.present(viewControllable.uiController, animated: animated)
    } else {
      self.uiController.navigationController?.present(viewControllable.uiController, animated: animated)
    }
  }

  func dismiss() {
    if let presented = self.uiController.presentedViewController {
      presented.dismiss(animated: true)
    } else {
      self.uiController.dismiss(animated: true)
    }
  }
  
  func presentMediumBottomSheet(_ viewControllable: ViewControllable, height: CGFloat = 300, animated: Bool) {
    let navigation = NavigationViewControllable(rootViewControllable: viewControllable)
    if let sheet = navigation.uiController.sheetPresentationController {
      sheet.prefersGrabberVisible = false
      sheet.preferredCornerRadius = 20
      sheet.detents = [
        .custom(identifier: nil, resolver: { _ in height })
      ]
    }
    if let nav = self.uiController as? UINavigationController {
      nav.present(navigation.uiController, animated: animated)
    } else {
      self.uiController.navigationController?.present(navigation.uiController, animated: animated)
    }
  }

  func presentBottomSheet(_ viewControllable: ViewControllable, animated: Bool) {
    let navigation = NavigationViewControllable(rootViewControllable: viewControllable)
    if let sheet = navigation.uiController.sheetPresentationController {
      sheet.prefersGrabberVisible = false
      sheet.preferredCornerRadius = 20
      sheet.detents = [
        .medium(),
        .small()
      ]
    }

    if let nav = self.uiController as? UINavigationController {
      nav.present(navigation.uiController, animated: animated)
    } else {
      self.uiController.navigationController?.present(navigation.uiController, animated: animated)
    }
  }
}

extension UISheetPresentationController.Detent {
  static func small(
      identifier: UISheetPresentationController.Detent.Identifier? = nil,
      resolvedValue:  CGFloat = 300
  ) -> UISheetPresentationController.Detent {
    return .custom { context in
      resolvedValue
    }
  }

//  static let small = UISheetPresentationController.Detent.Identifier("small")
}
