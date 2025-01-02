//
//  LikeBuilder.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import LikeInterface
import Core

public final class LikeBuilder: LikeBuildable {

  public init() { }
  public func build(rootViewControllable: ViewControllable) -> LikeCoordinating {
    let factory = LikeFactory()
    let buildable = MockChatRoomBuilder()
    let coordinator = LikeCoordinator(factory: factory, viewControllable: rootViewControllable)

    return coordinator
  }
}
