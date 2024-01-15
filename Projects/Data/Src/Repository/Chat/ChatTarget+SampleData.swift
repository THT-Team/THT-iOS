//
//  ChatTarget+SampleData.swift
//  Data
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import Networks

import Moya

extension ChatTarget {
  public var sampleData: Data {
    switch self {
    case .rooms:
      return Data(
    """
    [
      {
        "chatRoomIdx": 1,
        "partnerName": "채팅상대방이름",
        "partnerProfileUrl": "상대방프로필 url",
        "currentMessage": "최근 메세지",
        "messageTime": "2023-03-21T12:13:04.000000001",
        "isAvailableChat": true
      },
          {
            "chatRoomIdx": 2,
            "partnerName": "채팅상대방이름",
            "partnerProfileUrl": "상대방프로필 url",
            "currentMessage": "최근 메세지",
            "messageTime": "2023-03-21T12:13:04.000000001",
            "isAvailableChat": false
          },
          {
            "chatRoomIdx": 3,
            "partnerName": "채팅상대방이름",
            "partnerProfileUrl": "상대방프로필 url",
            "currentMessage": "최근 메세지",
            "messageTime": "2023-03-21T12:13:04.000000001",
            "isAvailableChat": true
          }
    ]
    """.utf8)

    default:
      return Data(
    """
    """.utf8)
    }
  }
}
