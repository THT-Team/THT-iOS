//
//  ChatMessagesRes.swift
//  Data
//
//  Created by Kanghos on 1/6/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation
import Domain

extension ChatMessage {
  struct Res: Decodable {
    let chatIdx: String
    let sender: String
    let senderUuid: String
    let msg: String
    let imgUrl: String
    let dateTime: Date
  }

  init(_ res: Res) {
    self.init(chatIdx: res.chatIdx, sender: res.sender, senderUuid: res.senderUuid, msg: res.msg, imgUrl: res.imgUrl, dataTime: res.dateTime)
  }
}

typealias ChatMessagesRes = [ChatMessage.Res]
