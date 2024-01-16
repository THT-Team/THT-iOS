//
//  ChatCoordinator.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import ChatInterface
import Core

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
  @Injected var chatUseCase: ChatUseCaseInterface

  public weak var delegate: ChatCoordinatorDelegate?

  public override func start() {

  }
}

extension ChatCoordinator: ChatCoordinating {
  public func homeFlow() {
    let viewModel = ChatHomeViewModel(chatUseCase: chatUseCase)
    viewModel.delegate = self
    let viewController = ChatHomeViewController(viewModel: viewModel)

    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func chatRoomFlow(_ item: ChatRoom) {
    let viewModel = ChatRoomViewModel(
      chatUseCase: chatUseCase,
      chatRoom: item
    )
    viewModel.delegate = self
    let viewController = ChatRoomViewController(viewModel: viewModel)

    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func notiFlow() {

  }
}

extension ChatCoordinator: ChatHomeDelegate {
  func itemTapped(_ room: ChatInterface.ChatRoom) {
    chatRoomFlow(room)
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
      chatRoomFlow(room)
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
