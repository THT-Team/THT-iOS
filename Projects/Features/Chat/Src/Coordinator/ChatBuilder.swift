//
//  ChatBuilder.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import DSKit

import ChatInterface

public final class ChatBuilder {
  public init() { }
}

extension ChatBuilder: ChatBuildable {
  public func build(rootViewControllable: ViewControllable) -> ChatCoordinating {
    let coordinator = ChatCoordinator(viewControllable: rootViewControllable)

    return coordinator
  }
}
