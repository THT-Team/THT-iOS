//
//  MainNavigator.swift
//  Falling
//
//  Created by SeungMin on 2023/08/15.
//

import UIKit

final class MainNavigator {
  let controller: UINavigationController

  init(controller: UINavigationController) {
    self.controller = controller
  }

  func toList() {
    let viewModel = MainViewModel(navigator: self)
    let viewController = MainViewController(viewModel: viewModel)
    self.controller.pushViewController(viewController, animated: true)
  }
}
