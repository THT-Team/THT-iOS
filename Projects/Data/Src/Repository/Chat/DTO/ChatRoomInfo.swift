//
//  ChatRoomInfoRes.swift
//  Data
//
//  Created by Kanghos on 1/6/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation

import Domain

extension ChatRoomInfo {
  struct Res: Decodable {
    let chatRoomIdx: Int
    let talkSubject: String
    let talkIssue: String
    let startDate: String
    let isChatAble: Bool
    let participants: [ChatRoomInfo.Participant.Res]
  }

  init(_ res: Res) {
    self.init(chatRoomIdx: res.chatRoomIdx, talkSubject: res.talkSubject, talkIssue: res.talkIssue, startDate: res.startDate, isChatAble: res.isChatAble, participants: res.participants.map(ChatRoomInfo.Participant.init))
  }
}

extension ChatRoomInfo.Participant {
  struct Res: Decodable {
    let id: String
    let name: String
    let profileURL: String

    enum CodingKeys: String, CodingKey {
      case id = "userUuid"
      case name = "userName"
      case profileURL = "profileUrl"
    }
  }

  init(_ res: Res) {
    self.init(id: res.id, name: res.name, profileURL: res.profileURL)
  }
}
