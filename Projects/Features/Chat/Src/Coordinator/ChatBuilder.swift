//
//  ChatBuilder.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import ChatInterface
import Core

public final class ChatBuilder: ChatBuildable {

  public init() { }
  public func build(rootViewControllable: ViewControllable) -> ChatCoordinating {

    let coordinator = ChatCoordinator(viewControllable: rootViewControllable)

    return coordinator
  }
}
