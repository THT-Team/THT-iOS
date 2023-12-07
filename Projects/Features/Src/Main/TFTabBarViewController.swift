//
//  TFTabBarViewController.swift
//  Feature
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

import Core

import DSKit

final class TFTabBarController: UITabBarController, MainViewControllable {
  var uiController: UIViewController { self }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    TFLogger.ui.debug("\(#function) \(type(of: self))")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    TFLogger.ui.debug("\(#function) \(type(of: self))")
  }
  
  func setViewController(_ viewControllables: [ViewControllable]) {
    super.setViewControllers(viewControllables.map { $0.uiController }, animated: false)
  }

  enum Feature: String {
    case falling
    case like
    case chat
    case myPage

    var image: DSKitImages {
      switch self {
      case .falling:
        return DSKitAsset.Image.falling
      case .like:
        return DSKitAsset.Image.heart
      case .chat:
        return DSKitAsset.Image.chat
      case .myPage:
        return DSKitAsset.Image.more

      }
    }
  }
}
