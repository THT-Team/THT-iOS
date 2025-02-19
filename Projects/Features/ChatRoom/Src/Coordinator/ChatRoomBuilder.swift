//
//  ChatRoomBuilder.swift
//  ChatRoom
//
//  Created by Kanghos on 1/6/25.
//

import Foundation
import Core
import ChatRoomInterface
import Domain

public final class ChatRoomBuilder: ChatRoomBuildable {
  private let factory: ChatRoomFactory

  public init(_ factory: ChatRoomFactory) {
    self.factory = factory
  }
  public func build(rootViewControllable: (any ViewControllable)) -> any ChatRoomInterface.ChatRoomCoordinating {
    return ChatRoomCoordinator(factory: factory, rootViewControllable)
  }
}
