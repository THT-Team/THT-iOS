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
    case .room(_):
      return Data("""
{
  "chatRoomIdx": 1,
  "talkSubject": "마음",
  "talkIssue": "너의 마음은 어떠니?",
  "startDate": "2025년 1월 30일",
  "isChatAble": true,
  "participants": [
    {
      "userUuid": "397d42f24a-b7a0-4bc3-8bc7-da8d18f56376",
      "userName": "1번 참가자 이름",
      "profileUrl": "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2023/07/14/bdb0ca50-5057-41e2-a024-8243c6f06279.jpg"
    },
    {
      "userUuid": "397d42f24a-b7a0-4bc3-8bc7-da8d18f56376",
      "userName": "2번 참가자 이름",
      "profileUrl": "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2023/07/14/bdb0ca50-5057-41e2-a024-8243c6f06279.jpg"
    }
  ]
}
""".utf8)
    case .out(_):
      return Data()
    case .history:
      return Data("""
[
  {
    "chatIdx": "1314objectIDa12134",
    "sender": "짱구",
    "senderUuid": "user-uuid",
    "msg": "채팅 내용",
    "imgUrl": "img-url",
    "dateTime": "2023-11-13T17:30:12.000001234"
  },
  {
    "chatIdx": "65f2d551d53ce4293c55dff1",
    "sender": "신사임당",
    "senderUuid": "46d960f565-2ae2-4193-96fd-31b6a8757611",
    "msg": "안녕하세요~~2233",
    "imgUrl": "user-profile-url",
    "dateTime": "2024-03-14T19:45:37.311199135"
  },
  {
    "chatIdx": "65f2d551d53ce4293c55dff2",
    "sender": "신사임당",
    "senderUuid": "46d960f565-2ae2-4193-96fd-31b6a8757611",
    "msg": "안녕하세요~~2233",
    "imgUrl": "user-profile-url",
    "dateTime": "2024-03-14T19:45:37.311199135"
  },
  {
    "chatIdx": "65f2d551d53ce4293c55dff3",
    "sender": "신사임당",
    "senderUuid": "46d960f565-2ae2-4193-96fd-31b6a8757611",
    "msg": "안녕하세요~~2233",
    "imgUrl": "user-profile-url",
    "dateTime": "2024-03-14T19:45:37.311199135"
  },
  {
    "chatIdx": "65f2d551d53ce4293c55dff4",
    "sender": "신사임당",
    "senderUuid": "46d960f565-2ae2-4193-96fd-31b6a8757611",
    "msg": "안녕하세요~~2233",
    "imgUrl": "user-profile-url",
    "dateTime": "2024-03-14T19:45:37.311199135"
  },
]
""".utf8)
    }
  }
}
