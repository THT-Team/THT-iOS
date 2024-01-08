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
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tabBar.frame.size.height = tabBarHeight + UIWindow.safeAreaInsetBottom
    tabBar.frame.origin.y = self.view.frame.height - tabBar.frame.size.height
  }
  
  func setViewController(_ viewControllables: [ViewControllable]) {
    super.setViewControllers(viewControllables.map { $0.uiController }, animated: false)
    setAppearance()
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
  enum TabItem {
    case falling
    case like
    case chat
    case myPage
    
    var title: String {
      switch self {
      case .falling:
        return "폴링"
      case .like:
        return "하트"
      case .chat:
        return "채팅"
      case .myPage:
        return "마이"
      }
    }
    
    var image: DSKitImages {
      switch self {
      case .falling:
        return DSKitAsset.Image.Tab.falling
      case .like:
        return DSKitAsset.Image.Tab.heart
      case .chat:
        return DSKitAsset.Image.Tab.chat
      case .myPage:
        return DSKitAsset.Image.Tab.more
      }
    }
    
    var selectedImage: DSKitImages {
      switch self {
      case .falling:
        return DSKitAsset.Image.Tab.fallingSelected
      case .like:
        return DSKitAsset.Image.Tab.heartSelected
      case .chat:
        return DSKitAsset.Image.Tab.chatSelected
      case .myPage:
        return DSKitAsset.Image.Tab.moreSelected
      }
    }
  }
  
  static func makeTabItem(_ item: TabItem) -> UITabBarItem {
    return UITabBarItem(
      title: item.title,
      image: item.image.image,
      selectedImage: item.selectedImage.image.withRenderingMode(.alwaysOriginal)
    )
  }
}
