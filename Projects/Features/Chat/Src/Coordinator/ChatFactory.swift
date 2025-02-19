//
//  ChatFactory.swift
//  Chat
//
//  Created by Kanghos on 2/5/25.
//

import Foundation
import DSKit
import Core
import Domain

import ChatRoomInterface
import ChatInterface

public final class ChatFactory {
  private let chatRoomBuilder: ChatRoomBuildable
  private let chatUseCase: ChatUseCaseInterface

  public init(
    chatRoomBuilder: ChatRoomBuildable,
    chatUseCase: ChatUseCaseInterface
  ) {
    self.chatRoomBuilder = chatRoomBuilder
    self.chatUseCase = chatUseCase
  }

  func makeChatHomeFlow() -> (ViewControllable, ChatHomeViewModel) {
    let vm = ChatHomeViewModel(chatUseCase: chatUseCase)
    let vc = ChatHomeViewController(viewModel: vm)

    return (vc, vm)
  }

  func makeChatRoomCoordinator(_ rootViewControllable: ViewControllable) -> ChatRoomCoordinating {
    let coordinator = chatRoomBuilder.build(rootViewControllable: rootViewControllable)
    return coordinator
  }
}
