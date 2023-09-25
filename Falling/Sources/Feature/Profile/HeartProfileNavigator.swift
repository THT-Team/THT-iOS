//
//  HeartProfileNavigator.swift
//  Falling
//
//  Created by Kanghos on 2023/09/17.
//

import UIKit

protocol HeartProfileNavigatorType {
  func toHeartList()
  func toChatRoom(id: String)
}

final class HeartProfileNavigator: HeartProfileNavigatorType {

  let controller: UINavigationController
  let heartService: any HeartAPIType

  init(controller: UINavigationController, heartService: any HeartAPIType) {
    self.controller = controller
    self.heartService = heartService
  }

  func toHeartList() {
    controller.dismiss(animated: true)
  }

  func toChatRoom(id: String) {
    controller.dismiss(animated: true) { [weak self] in
      let vc = UIViewController()
      vc.title = "채팅룸"
      vc.view.backgroundColor = FallingAsset.Color.neutral600.color
      self?.controller.pushViewController(vc, animated: true)
    }
    TFLogger.view.notice("toChatRoom")
  }

}
