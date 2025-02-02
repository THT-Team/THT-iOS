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

  public init(chatRoomIdx: Int, talkSubject: String, talkIssue: String, startDate: String, isChatAble: Bool) {
    self.chatRoomIdx = chatRoomIdx
    self.talkSubject = talkSubject
    self.talkIssue = talkIssue
    self.startDate = startDate
    self.isChatAble = isChatAble
  }
}
