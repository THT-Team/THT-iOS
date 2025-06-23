//
//  ChatViewSection.swift
//  ChatRoom
//
//  Created by Kanghos on 1/25/25.
//

import Foundation
import Domain

public enum BubbleState: Equatable {
  case single
  case head
  case tail
  case middle
}

public struct ChatViewSection: Hashable {
  let date: Date
  var items: [ChatViewSectionItem]
}

public struct ChatViewSectionItem: Hashable {
  var message: ChatMessageItem
  let reactor: BubbleReactor
  
  var type: MessageSendType {
    message.senderType
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(message)
  }
}

extension ChatViewSectionItem: Equatable {
  public static func == (lhs: ChatViewSectionItem, rhs: ChatViewSectionItem) -> Bool {
    lhs.message == rhs.message
  }
}

//extension ChatMessage: @retroactive Hashable {
//  public static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
//    lhs.id == rhs.id
//  }
//
//  var id: String { chatIdx }
//
//  public func hash(into hasher: inout Hasher) {
//    hasher.combine(id)
//  }
//}
