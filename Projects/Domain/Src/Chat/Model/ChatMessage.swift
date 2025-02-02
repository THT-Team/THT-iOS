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
