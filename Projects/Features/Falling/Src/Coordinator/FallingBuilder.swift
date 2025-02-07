//
//  FallingBuilder.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

import FallingInterface
import Core
import ChatRoomInterface

public final class FallingBuilder: FallingBuildable {
  private let chatRoomBuilder: ChatRoomBuildable

  public init(chatRoomBuilder: ChatRoomBuildable) {
    self.chatRoomBuilder = chatRoomBuilder
  }
  public func build(rootViewControllable: ViewControllable) -> FallingCoordinating {

    let coordinator = FallingCoordinator(chatRoomBuilder: chatRoomBuilder, viewControllable: rootViewControllable)

    return coordinator
  }
}
