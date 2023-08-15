//
//  RoomResponse.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import Foundation

// MARK: - Rooms
struct RoomResponse: Codable {
    let chatRoomIndex: Int
    let talkSubject, talkIssue, startDate: String

  enum CodingKeys: String, CodingKey {
    case chatRoomIndex = "chatRoomIdx"
    case talkSubject, talkIssue, startDate
  }
}

