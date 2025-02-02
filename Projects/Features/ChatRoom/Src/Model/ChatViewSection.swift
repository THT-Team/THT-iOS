//
//  ChatViewSection.swift
//  ChatRoom
//
//  Created by Kanghos on 1/25/25.
//

import Foundation
import Domain

public struct ChatViewSection: Hashable {
  var items: [ChatViewSectionItem]
}

public enum ChatViewSectionKind: Hashable {
  case main
}

public enum ChatViewSectionItem: Hashable {
  case incoming(BubbleReactor)
  case outgoing(BubbleReactor)

  var chatIndex: String {
    switch self {
    case .incoming(let bubbleReactor):
      return bubbleReactor.currentState.index
    case .outgoing(let bubbleReactor):
      return bubbleReactor.currentState.index
    }
  }
}

extension ChatMessage: @retroactive Equatable {}
extension ChatMessage: @retroactive Hashable {
  public static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
    lhs.id == rhs.id
  }

  var id: String { chatIdx }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  var isMe: Bool {
    return self.senderUuid == ""
  }
}
