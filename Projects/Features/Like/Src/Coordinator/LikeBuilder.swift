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
  private let factory: LikeFactory

  public init(chatRoomBuilder: ChatRoomBuildable, factory: LikeFactory) {
    self.chatRoomBuilder = chatRoomBuilder
    self.factory = factory
  }
  
  public func build(rootViewControllable: ViewControllable) -> LikeCoordinating {
    let coordinator = LikeCoordinator(factory: factory, viewControllable: rootViewControllable)

    return coordinator
  }
}
