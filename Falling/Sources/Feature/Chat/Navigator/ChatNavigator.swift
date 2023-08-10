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

  func toList() {
    let viewModel = ChatListViewModel(navigator: self)
    let viewController = ChatListViewController(viewModel: viewModel)
    self.controller.pushViewController(viewController, animated: true)
  }
}
