//
//  TFTabBarViewController.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import UIKit

protocol TabBarDependnecy: AnyObject {
  var tabBarHeight: CGFloat { get }
}

final class TabBarComponent: TabBarDependnecy {
  var tabBarHeight: CGFloat = 56
}

final class TFTabBarController: UITabBarController {
  private let dependnecy: TabBarDependnecy
  init(dependency: TabBarDependnecy) {
    self.dependnecy = dependency
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) hazs not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setAppearance()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tabBar.frame.size.height = dependnecy.tabBarHeight + UIWindow.safeAreaInsetBottom
    tabBar.frame.origin.y = self.view.frame.height - tabBar.frame.size.height
  }

// https://emptytheory.com/2019/12/31/using-uitabbarappearance-for-tab-bar-changes-in-ios-13/
  private func setAppearance() {
    let tabBarAppearance = UITabBarAppearance()
    tabBarAppearance.backgroundColor = FallingAsset.Color.neutral700.color
    tabBarAppearance.shadowColor = FallingAsset.Color.neutral600.color
    self.tabBar.isTranslucent = false

    setTabItemAppearence(tabBarAppearance.stackedLayoutAppearance)
    self.tabBar.standardAppearance = tabBarAppearance
    self.tabBar.scrollEdgeAppearance = tabBarAppearance
  }

  private func setTabItemAppearence(_ itemAppearance: UITabBarItemAppearance) {
    itemAppearance.normal.titleTextAttributes = [
      .foregroundColor: FallingAsset.Color.unSelected.color,
      .font: UIFont.thtCaption1M
    ]
    itemAppearance.selected.titleTextAttributes = [
      .foregroundColor: FallingAsset.Color.neutral50.color,
      .font: UIFont.thtCaption1M
    ]
  }
}
