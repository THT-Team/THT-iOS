//
//  ChatRoom.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

public struct ChatRoom {
  public let chatRoomIndex: Int
  public let partnerName, partnerProfileURL, currentMessage: String
  public let messageTime: Date
  public let isAvailableChat: Bool

  public init(chatRoomIndex: Int, partnerName: String, partnerProfileURL: String, currentMessage: String, messageTime: Date, isAvailableChat: Bool) {
    self.chatRoomIndex = chatRoomIndex
    self.partnerName = partnerName
    self.partnerProfileURL = partnerProfileURL
    self.currentMessage = currentMessage
    self.messageTime = messageTime
    self.isAvailableChat = isAvailableChat
  }
}

extension ChatRoom: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(chatRoomIndex)
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.chatRoomIndex == rhs.chatRoomIndex
  }
}
