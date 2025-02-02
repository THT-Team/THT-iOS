//
//  ChatMessage.swift
//  Domain
//
//  Created by Kanghos on 1/5/25.
//

import Foundation

public struct ChatMessage {
  public let chatIdx: String
  public let sender: String
  public let senderUuid: String
  public let msg: String
  public let imgUrl: String
  public let dateTime: Date

  public init(chatIdx: String, sender: String, senderUuid: String, msg: String, imgUrl: String, dataTime: Date) {
    self.chatIdx = chatIdx
    self.sender = sender
    self.senderUuid = senderUuid
    self.msg = msg
    self.imgUrl = imgUrl
    self.dateTime = dataTime
  }
}

extension ChatMessage {
  public struct Request: Encodable {
    public let sender: String
    public let senderUUID: String
    public let imageURL: String
    public let message: String

    private enum CodingKeys: String, CodingKey {
      case sender
      case senderUUID = "senderUuid"
      case imageURL = "imgUrl"
      case message = "msg"
    }

    public init(sender: String, senderUUID: String, imageURL: String, message: String) {
      self.sender = sender
      self.senderUUID = senderUUID
      self.imageURL = imageURL
      self.message = message
    }

    public init(participant: ChatRoomInfo.Participant, message: String) {
      self.init(sender: participant.name, senderUUID: participant.id, imageURL: participant.profileURL, message: message)
    }
  }

  public struct Response: Decodable {
    public let chatIndex: String
    public let sender: String
    public let senderUUID: String
    public let message: String
    public let imageURL: String
    public let dateTime: Date

    private enum CodingKeys: String, CodingKey {
      case chatIndex = "chatIdx"
      case sender
      case senderUUID = "senderUuid"
      case imageURL = "imgUrl"
      case message = "msg"
      case dateTime
    }

    public func toDomain() -> ChatMessage {
      ChatMessage(chatIdx: chatIndex, sender: sender, senderUuid: senderUUID, msg: message, imgUrl: imageURL, dataTime: dateTime)
    }
  }
}
