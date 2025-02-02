//
//  ChatRoomInfo.swift
//  Domain
//
//  Created by Kanghos on 1/5/25.
//

import Foundation

public struct ChatRoomInfo {
  public let chatRoomIdx: Int
  public let talkSubject: String
  public let talkIssue: String
  public let startDate: String
  public let isChatAble: Bool
  public let participants: [Participant]

  public init(chatRoomIdx: Int, talkSubject: String, talkIssue: String, startDate: String, isChatAble: Bool,
              participants: [Participant]
  ) {
    self.chatRoomIdx = chatRoomIdx
    self.talkSubject = talkSubject
    self.talkIssue = talkIssue
    self.startDate = startDate
    self.isChatAble = isChatAble
    self.participants = participants
  }

  public struct Participant {
    public let id: String
    public let name: String
    public let profileURL: String

    public init(id: String, name: String, profileURL: String) {
      self.id = id
      self.name = name
      self.profileURL = profileURL
    }
  }
}
