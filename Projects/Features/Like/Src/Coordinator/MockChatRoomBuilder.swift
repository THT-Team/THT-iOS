//
//  MockChatRoomBuilder.swift
//  Like
//
//  Created by Kanghos on 2024/05/03.
//

import Foundation
import Core

protocol ChatRoomBuildable {
  func build(rootViewControllable: ViewControllable, listener: ChatRoomCoordinatorDelegate) -> ChatRoomCoordinating
}

class MockChatRoomBuilder: ChatRoomBuildable {
  public init() { }
  public func build(rootViewControllable: ViewControllable, listener: ChatRoomCoordinatorDelegate) -> ChatRoomCoordinating {

    let coordinator = MockChatCoordinator(viewControllable: rootViewControllable)
    coordinator.delegate = listener
    return coordinator
  }
}
