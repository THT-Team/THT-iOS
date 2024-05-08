//
//  MockChatCoordinator.swift
//  Like
//
//  Created by Kanghos on 2024/05/03.
//

import Foundation
import Core

protocol ChatRoomCoordinating: Coordinator {
  var delegate: ChatRoomCoordinatorDelegate? { get set }
  func chatRoomFlow()
  func profileFLow()
  func photoselect()
  func logout()
}

// MARK: Communicate Parent Coordinator
protocol ChatRoomCoordinatorDelegate: AnyObject {
  func didFinishChatRoomCoordinator(_ coordinator: Coordinator?) // release Coordinator
}

enum ChatRoomCoordinatorAction {
  case finish
}

protocol ChatRoomActionDelegate: AnyObject {
  func invoke(_ action: ChatRoomCoordinatorAction)
}

class MockChatCoordinator: BaseCoordinator, ChatRoomCoordinating  {
  weak var delegate: ChatRoomCoordinatorDelegate?
  func chatRoomFlow() {
    let vc = MockChatRoomViewController()
    vc.delegate = self

    self.viewControllable.pushViewController(vc, animated: true)
  }
}

// MARK: process ChatRoom navigation action
extension MockChatCoordinator: ChatRoomActionDelegate {
  func invoke(_ action: ChatRoomCoordinatorAction) {
    switch action {
    case .finish:
      self.delegate?.didFinishChatRoomCoordinator(self)
    }
  }
}
