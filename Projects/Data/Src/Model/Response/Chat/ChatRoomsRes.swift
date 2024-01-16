//
//  ChatRoomsRes.swift
//  Data
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import Core
import ChatInterface

// MARK: - ChatRoomsResponseElement
struct ChatRoomRes: Codable {
    let chatRoomIdx: Int
    let partnerName, partnerProfileURL, currentMessage, messageTime: String
    let isAvailableChat: Bool

    enum CodingKeys: String, CodingKey {
        case chatRoomIdx, partnerName
        case partnerProfileURL = "partnerProfileUrl"
        case currentMessage, messageTime, isAvailableChat
    }
}

typealias ChatRoomsRes = [ChatRoomRes]

extension ChatRoomRes {
  func toDomain() -> ChatRoom {
    ChatRoom(
      chatRoomIndex: self.chatRoomIdx,
      partnerName: self.partnerName,
      partnerProfileURL: self.partnerProfileURL,
      currentMessage: self.currentMessage,
      messageTime: self.messageTime.toDate(),
      isAvailableChat: self.isAvailableChat
    )
  }
}

