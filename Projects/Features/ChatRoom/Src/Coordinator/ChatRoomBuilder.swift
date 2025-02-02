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

  public init() {} 
  public func build(_ userUUID: String, rootViewControllable: any Core.ViewControllable, talkUseCase: TalkUseCaseInterface) -> any ChatRoomInterface.ChatRoomCoordinating {
    return ChatRoomCoordinator(factory: ChatRoomFactory(talkUseCase: talkUseCase), rootViewControllable)
  }
}
