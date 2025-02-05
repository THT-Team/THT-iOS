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

  private let talkUseCase: TalkUseCaseInterface
  public init(talkUseCase: TalkUseCaseInterface) {
    self.talkUseCase = talkUseCase
  }
  public func build(rootViewControllable: any Core.ViewControllable) -> any ChatRoomInterface.ChatRoomCoordinating {
    return ChatRoomCoordinator(factory: ChatRoomFactory(talkUseCase: talkUseCase), rootViewControllable)
  }
}
