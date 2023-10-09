//
//  MainNavigator.swift
//  Falling
//
//  Created by SeungMin on 2023/08/15.
//

import UIKit

final class MainNavigator {
  let controller: UINavigationController
  let service: FallingAPI

  init(controller: UINavigationController, fallingService: FallingAPI) {
    self.controller = controller
    self.service = fallingService
  }

  func toList() {
    let viewModel = MainViewModel(navigator: self, service: service)
    let viewController = MainViewController(viewModel: viewModel)
    self.controller.pushViewController(viewController, animated: true)
  }
}
