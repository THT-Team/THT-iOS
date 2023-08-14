//
//  ChatNavigator.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import UIKit

final class ChatNavigator {
  let controller: UINavigationController

  init(controller: UINavigationController) {
    self.controller = controller
  }

  func toChatRoom(id: String) {

  }

  func toImageTest() {
    let viewmodel = ImageTestViewModel(navigator: self)
    let viewController = ImageTestViewController(viewModel: viewmodel)
    self.controller.pushViewController(viewController, animated: true)
  }

  func toList() {
    let viewModel = ChatListViewModel(navigator: self)
    let viewController = ChatListViewController(viewModel: viewModel)
    self.controller.pushViewController(viewController, animated: true)
  }
}
