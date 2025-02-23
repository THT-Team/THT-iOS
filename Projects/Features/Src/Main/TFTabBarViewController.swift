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
  let tabBarHeight: CGFloat = 56
  
  init() {
    super.init(nibName: nil, bundle: nil)
    TFLogger.ui.debug("\(#function) \(type(of: self))")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    TFLogger.ui.debug("\(#function) \(type(of: self))")
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tabBar.frame.size.height = tabBarHeight + UIWindow.safeAreaInsetBottom
    tabBar.frame.origin.y = self.view.frame.height - tabBar.frame.size.height
  }

  func setViewControllers(_ viewControllerables: [ViewControllable]) {
    setAppearance()

    self.setViewControllers(viewControllerables.map(\.uiController), animated: false)
  }
  
  private func setAppearance() {
    let tabBarAppearance = UITabBarAppearance()
    tabBarAppearance.backgroundColor = DSKitAsset.Color.neutral700.color
    tabBarAppearance.shadowColor = DSKitAsset.Color.neutral600.color
    self.tabBar.isTranslucent = false

    setTabItemAppearence(tabBarAppearance.stackedLayoutAppearance)
    self.tabBar.standardAppearance = tabBarAppearance
    self.tabBar.scrollEdgeAppearance = tabBarAppearance
  }
  
  private func setTabItemAppearence(_ itemAppearance: UITabBarItemAppearance) {
    itemAppearance.normal.titleTextAttributes = [
      .foregroundColor: DSKitAsset.Color.unSelected.color,
      .font: UIFont.thtCaption1M
    ]
    itemAppearance.selected.titleTextAttributes = [
      .foregroundColor: DSKitAsset.Color.neutral50.color,
      .font: UIFont.thtCaption1M
    ]
  }
}

extension UITabBarItem {
  static let falling = UITabBarItem(title: "폴링", image: DSKitAsset.Image.Tab.falling.image, selectedImage: DSKitAsset.Image.Tab.fallingSelected.image.withRenderingMode(.alwaysOriginal))
  static let like = UITabBarItem(title: "하트", image: DSKitAsset.Image.Tab.heart.image, selectedImage: DSKitAsset.Image.Tab.heartSelected.image.withRenderingMode(.alwaysOriginal))
  static let chat = UITabBarItem(title: "채팅", image: DSKitAsset.Image.Tab.chat.image, selectedImage: DSKitAsset.Image.Tab.chatSelected.image.withRenderingMode(.alwaysOriginal))
  static let myPage = UITabBarItem(title: "마이", image: DSKitAsset.Image.Tab.more.image, selectedImage: DSKitAsset.Image.Tab.moreSelected.image.withRenderingMode(.alwaysOriginal))
  }
