//
//  ChatNavigator.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import UIKit

final class HeartNavigator {
  let controller: UINavigationController
  let heartService: HeartAPI

  init(controller: UINavigationController, heartService: HeartAPI) {
    self.controller = controller
    self.heartService = heartService
  }

  func toProfile(item: LikeDTO) {
    let navigator = HeartProfileNavigator(
      controller: self.controller,
      heartService: self.heartService)

    let viewModel = HeartProfileViewModel(service: self.heartService,
                                         navigator: navigator,
                                         likeItem: item)
    let vc = ProfileViewController(viewModel: viewModel)
    vc.modalPresentationStyle = .overFullScreen
    vc.modalTransitionStyle = .crossDissolve
    controller.present(vc, animated: true)
  }

  func popToList() {
    controller.popViewController(animated: true)
  }

  func toChatRoom(id: String) {
    let viewController = UIViewController()
    viewController.view.backgroundColor = FallingAsset.Color.neutral700.color
    viewController.title = "채팅룸"
    self.controller.pushViewController(viewController, animated: true)
  }
  

  func toList() {
    let viewModel = HeartListViewModel(navigator: self, service: self.heartService)
    let viewController = HeartListViewController(viewModel: viewModel)
    self.controller.pushViewController(viewController, animated: true)
  }
}
