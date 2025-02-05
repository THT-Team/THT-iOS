//
//  ChatCoordinator.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import ChatInterface
import Core
import Domain
import ChatRoomInterface

enum ChatCoordinatingAction {
  case backButtonTapped
  case roomItemTapped(_ item: ChatRoom)
  case notiTapped
  case reportTapped
  case exitTapped
}

protocol ChatCoordinatingActionDelegate: AnyObject {
  func invoke(_ action: ChatCoordinatingAction)
}

public final class ChatCoordinator: BaseCoordinator {
  private let factory: ChatFactory

  public weak var delegate: ChatCoordinatorDelegate?

  public init(factory: ChatFactory, viewControllable: ViewControllable) {
    self.factory = factory
    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    homeFlow()
  }
}

extension ChatCoordinator: ChatCoordinating {
  public func homeFlow() {
    let (vc, vm) = factory.makeChatHomeFlow()

    vm.delegate = self

    self.viewControllable.setViewControllers([vc])
  }

  public func chatRoomFlow(_ chatIndex: String) {
    TFLogger.dataLogger.info("ChatRoom - \(chatIndex)!")
    var coordinator = factory.makeChatRoomCoordinator( self.viewControllable)
    coordinator.finishFlow = { [weak self, weak coordinator] message in
      guard let self, let coordinator else { return }
      coordinator.childCoordinators.removeAll()
      self.detachChild(coordinator)
    }
    attachChild(coordinator)
    coordinator.chatRoomFlow(chatIndex)
  }

  public func notiFlow() {

  }
}

extension ChatCoordinator: ChatHomeDelegate {
  func itemTapped(_ room: ChatRoom) {
    chatRoomFlow(String(room.chatRoomIndex))
  }
  
  func notiTapped() {
    notiFlow()
  }
}

extension ChatCoordinator: ChatCoordinatingActionDelegate {
  func invoke(_ action: ChatCoordinatingAction) {
    switch action {
    case .backButtonTapped:
      self.viewControllable.popViewController(animated: true)
    case .roomItemTapped(let room):
      chatRoomFlow(String(room.chatRoomIndex))
    case .notiTapped:
      notiFlow()
    case .reportTapped:
      TFLogger.ui.info("report Clicked!")
    case .exitTapped:
      TFLogger.ui.info("exit Clicked!")
      self.viewControllable.popViewController(animated: true)
    }
  }
}
