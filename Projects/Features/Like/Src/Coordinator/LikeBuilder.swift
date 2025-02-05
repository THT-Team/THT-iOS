//
//  LikeBuilder.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import LikeInterface
import ChatRoomInterface
import Core
import Domain

public final class LikeBuilder: LikeBuildable {

  private let chatRoomBuilder: ChatRoomBuildable

  public init(chatRoomBuilder: ChatRoomBuildable) {
    self.chatRoomBuilder = chatRoomBuilder
  }
  
  public func build(rootViewControllable: ViewControllable, talkUseCase: TalkUseCaseInterface) -> LikeCoordinating {
    let factory = LikeFactory(chatRoomBuilder: chatRoomBuilder, talkUseCase: talkUseCase)
    let coordinator = LikeCoordinator(factory: factory, viewControllable: rootViewControllable)

    return coordinator
  }
}
