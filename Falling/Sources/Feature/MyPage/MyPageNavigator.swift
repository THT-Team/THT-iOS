//
//  MyPageNavigator.swift
//  Falling
//
//  Created by SeungMin on 2023/08/15.
//

import UIKit

final class MyPageNavigator {
  let controller: UINavigationController
  
  init(controller: UINavigationController) {
    self.controller = controller
  }
  
  func toList() {
    let viewModel = MyPageViewModel(navigator: self)
    let viewController = MyPageViewController(viewModel: viewModel)
    self.controller.pushViewController(viewController, animated: true)
  }
}
