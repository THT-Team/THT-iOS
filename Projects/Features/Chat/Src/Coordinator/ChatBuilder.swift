//
//  ChatBuilder.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import DSKit

import ChatInterface
import ChatRoomInterface
import Domain

public final class ChatBuilder {
  private let chatRoomBuilder: ChatRoomBuildable

  public init(chatRoomBuilder: ChatRoomBuildable) {
    self.chatRoomBuilder = chatRoomBuilder
  }
}

extension ChatBuilder: ChatBuildable {
  public func build(rootViewControllable: ViewControllable) -> ChatCoordinating {
    let coordinator = ChatCoordinator(factory: ChatFactory(chatRoomBuilder: chatRoomBuilder), viewControllable: rootViewControllable)

    return coordinator
  }
}
