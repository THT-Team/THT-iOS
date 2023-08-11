//
//  HistoryResponse.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import Foundation

// MARK: - HistoryResponseElement
struct HistoryResponse: Codable {
  let chatIndex, sender, senderUUID, message: String
  let imgURL, dateTime: String

  enum CodingKeys: String, CodingKey {
    case chatIndex = "chatIdx"
    case sender
    case senderUUID = "senderUuid"
    case message = "msg"
    case imgURL = "imgUrl"
    case dateTime
  }
}

typealias HistoriesResponse = [HistoryResponse]

