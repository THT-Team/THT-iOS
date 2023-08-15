//
//  RoomsResponse.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import Foundation

// MARK: - Room
typealias RoomsResponse = [RoomItem]

struct RoomItem: Codable {
  let chatRoomIndex: Int
  let partnerName, partnerProfileURL, currentMessage, messageTime: String

  enum CodingKeys: String, CodingKey {
    case chatRoomIndex = "chatRoomIdx"
    case partnerName
    case partnerProfileURL = "partnerProfileUrl"
    case currentMessage, messageTime
  }
}

