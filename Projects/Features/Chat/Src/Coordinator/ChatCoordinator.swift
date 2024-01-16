//
//  ChatCoordinator.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import ChatInterface
import Core

public final class ChatCoordinator: BaseCoordinator, ChatCoordinating {
  @Injected var chatUseCase: ChatUseCaseInterface

  public weak var delegate: ChatCoordinatorDelegate?
  
  public override func start() {
    homeFlow()
  }

  public func homeFlow() {
    let viewModel = ChatHomeViewModel(chatUseCase: chatUseCase)
//    viewModel.delegate = self

    let viewController = ChatHomeViewController(viewModel: viewModel)

    self.viewControllable.setViewControllers([viewController])
  }
}

