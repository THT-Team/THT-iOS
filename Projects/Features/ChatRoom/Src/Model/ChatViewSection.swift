//
//  ChatViewSection.swift
//  ChatRoom
//
//  Created by Kanghos on 1/25/25.
//

import Foundation
import Domain

public struct ChatViewSection: Hashable {
  let date: Date
  var items: [ChatViewSectionItem]
}

public struct ChatViewSectionItem: Hashable {
  var message: ChatMessageType
  var isLinked: Bool
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(message)
  }
}

extension ChatViewSectionItem: Equatable {
  public static func == (lhs: ChatViewSectionItem, rhs: ChatViewSectionItem) -> Bool {
    lhs.message == rhs.message &&
    lhs.isLinked == rhs.isLinked
  }
}

//public enum ChatViewSectionItem: Hashable {
//  case incoming(BubbleReactor)
//  case outgoing(BubbleReactor)
//
//  var chatIndex: String {
//    switch self {
//    case .incoming(let bubbleReactor), .outgoing(let bubbleReactor):
//      return bubbleReactor.currentState.index
//    }
//  }
//  
//  var date: String {
//    switch self {
//    case .incoming(let reactor), .outgoing(let reactor):
//      return reactor.currentState.dateText
//    }
//  }
//  
//  var sendType: MessageSendType {
//    switch self {
//    case .incoming: return .incoming
//    case .outgoing: return .outgoing
//    }
//  }
//}

extension ChatMessage: @retroactive Hashable {
  public static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
    lhs.id == rhs.id
  }

  var id: String { chatIdx }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
