//
//  ChatNavigator.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import UIKit

final class HeartNavigator {
  let controller: UINavigationController

  init(controller: UINavigationController) {
    self.controller = controller
  }

  func toChatRoom(id: String) {

  }

  func toProfile(id: String) {

  }
  

  func toList() {
    let viewModel = HeartListViewModel(navigator: self)
    let viewController = HeartListViewController(viewModel: viewModel)
    self.controller.pushViewController(viewController, animated: true)
  }
}
