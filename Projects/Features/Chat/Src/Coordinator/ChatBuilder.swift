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
  private let factory: ChatFactory

  public init(chatRoomBuilder: ChatRoomBuildable, factory: ChatFactory) {
    self.chatRoomBuilder = chatRoomBuilder
    self.factory = factory
  }
}

extension ChatBuilder: ChatBuildable {
  public func build(rootViewControllable: ViewControllable) -> ChatCoordinating {
    let coordinator = ChatCoordinator(factory: factory, viewControllable: rootViewControllable)

    return coordinator
  }
}
