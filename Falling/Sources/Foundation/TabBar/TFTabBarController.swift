//
//  TFTabBarViewController.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import UIKit

import RxSwift

protocol TabBarDependnecy: AnyObject {

}

final class TabBarComponent: TabBarDependnecy {

}

final class TFTabBarController: UITabBarController {
  private let dependnecy: TabBarDependnecy
  init(dependency: TabBarDependnecy) {
    self.dependnecy = dependency
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setAppearance()
  }

// https://emptytheory.com/2019/12/31/using-uitabbarappearance-for-tab-bar-changes-in-ios-13/
  private func setAppearance() {
    let appearence = UITabBarAppearance()

    appearence.backgroundColor = FallingAsset.Color.netural700.color
    appearence.shadowColor = FallingAsset.Color.netural600.color
    self.tabBar.isTranslucent = false

    setTabItemAppearence(appearence.stackedLayoutAppearance)
    self.tabBar.scrollEdgeAppearance = appearence
    self.tabBar.standardAppearance = appearence
  }

  private func setTabItemAppearence(_ itemAppearence: UITabBarItemAppearance) {
    itemAppearence.normal.titleTextAttributes = [
      .foregroundColor: FallingAsset.Color.unSelected.color,
      .font: UIFont.thtCaption1M
    ]
    itemAppearence.normal.titlePositionAdjustment.vertical = 10
    itemAppearence.selected.titleTextAttributes = [
      .foregroundColor: FallingAsset.Color.netural50.color,
      .font: UIFont.thtCaption1M
    ]

  }
}
