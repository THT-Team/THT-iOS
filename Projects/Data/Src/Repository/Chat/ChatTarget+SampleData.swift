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
        "partnerProfileUrl": "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2023/07/14/bdb0ca50-5057-41e2-a024-8243c6f06279.jpg",
        "currentMessage": "최근 메세지",
        "messageTime": "2023-03-21T12:13:04.000000001",
        "isAvailableChat": true
      },
          {
            "chatRoomIdx": 2,
            "partnerName": "채팅상대방이름",
            "partnerProfileUrl": "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2023/07/14/bdb0ca50-5057-41e2-a024-8243c6f06279.jpg",
            "currentMessage": "최근 메세지",
            "messageTime": "2023-03-21T12:13:04.000000001",
            "isAvailableChat": false
          },
          {
            "chatRoomIdx": 3,
            "partnerName": "채팅상대방이름",
            "partnerProfileUrl": "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2023/07/14/bdb0ca50-5057-41e2-a024-8243c6f06279.jpg",
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
      "userUuid": "471383b57f-0715-4949-a5b2-ae816353438b",
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
        "chatIdx": "1000objectIDf08cb8",
        "sender": "짱구",
        "senderUuid": "55bc01ac-b7ef-48e2-b9eb-5dd06e251832",
        "msg": "메시지 내용 1",
        "imgUrl": "https://example.com/image1.jpg",
        "dateTime": "2025-06-13T10:33:53.306069"
      },
      {
        "chatIdx": "1001objectID776fe2",
        "sender": "철수",
        "senderUuid": "368d8bac-f558-4e2b-8501-5f46550b525f",
        "msg": "메시지 내용 2",
        "imgUrl": "https://example.com/image2.jpg",
        "dateTime": "2025-06-13T11:48:52.306069"
      },
      {
        "chatIdx": "1002objectIDc27398",
        "sender": "짱구",
        "senderUuid": "55bc01ac-b7ef-48e2-b9eb-5dd06e251832",
        "msg": "메시지 내용 3",
        "imgUrl": "https://example.com/image3.jpg",
        "dateTime": "2025-06-13T12:37:18.306069"
      },
      {
        "chatIdx": "1003objectIDc2a9e5",
        "sender": "철수",
        "senderUuid": "368d8bac-f558-4e2b-8501-5f46550b525f",
        "msg": "메시지 내용 4",
        "imgUrl": "https://example.com/image4.jpg",
        "dateTime": "2025-06-14T12:58:14.306069"
      },
      {
        "chatIdx": "1004objectID8b2f12",
        "sender": "짱구",
        "senderUuid": "55bc01ac-b7ef-48e2-b9eb-5dd06e251832",
        "msg": "메시지 내용 5",
        "imgUrl": "https://example.com/image5.jpg",
        "dateTime": "2025-06-14T13:43:23.306069"
      },
      {
        "chatIdx": "1005objectIDc1cb99",
        "sender": "철수",
        "senderUuid": "368d8bac-f558-4e2b-8501-5f46550b525f",
        "msg": "메시지 내용 6",
        "imgUrl": "https://example.com/image6.jpg",
        "dateTime": "2025-06-14T14:58:49.306069"
      },
      {
        "chatIdx": "1006objectID0b3f5b",
        "sender": "짱구",
        "senderUuid": "55bc01ac-b7ef-48e2-b9eb-5dd06e251832",
        "msg": "메시지 내용 7",
        "imgUrl": "https://example.com/image7.jpg",
        "dateTime": "2025-06-15T14:33:42.306069"
      },
      {
        "chatIdx": "1007objectIDa25dcc",
        "sender": "철수",
        "senderUuid": "368d8bac-f558-4e2b-8501-5f46550b525f",
        "msg": "메시지 내용 8",
        "imgUrl": "https://example.com/image8.jpg",
        "dateTime": "2025-06-15T14:14:56.306069"
      },
      {
        "chatIdx": "1008objectIDc7de1b",
        "sender": "짱구",
        "senderUuid": "55bc01ac-b7ef-48e2-b9eb-5dd06e251832",
        "msg": "메시지 내용 9",
        "imgUrl": "https://example.com/image9.jpg",
        "dateTime": "2025-06-15T14:55:07.306069"
      },
      {
        "chatIdx": "1009objectIDc2272e",
        "sender": "철수",
        "senderUuid": "368d8bac-f558-4e2b-8501-5f46550b525f",
        "msg": "메시지 내용 10",
        "imgUrl": "https://example.com/image10.jpg",
        "dateTime": "2025-06-15T14:29:59.306069"
      },
      {
        "chatIdx": "1009objectIDc22726",
        "sender": "철수",
        "senderUuid": "368d8bac-f558-4e2b-8501-5f46550b525f",
        "msg": "화자 같음 시간 다름",
        "imgUrl": "https://example.com/image10.jpg",
        "dateTime": "2025-06-15T14:28:59.306069"
      },
      {
        "chatIdx": "1009objectIDc22727",
        "sender": "철수",
        "senderUuid": "368d8bac-f558-4e2b-8501-5f46550b525f",
        "msg": "시간 같음 화자 같음",
        "imgUrl": "https://example.com/image10.jpg",
        "dateTime": "2025-06-15T14:29:59.306069"
      },
      {
        "chatIdx": "1009objectIDc22728",
        "sender": "철수",
        "senderUuid": "368d8bac-f558-4e2b-8501-5f46550b525f",
        "msg": "시간 같음 화자 같음",
        "imgUrl": "https://example.com/image10.jpg",
        "dateTime": "2025-06-15T14:29:59.306069"
      }
    ]
""".utf8)
//[
//  {
//    "chatIdx": "1314objectIDa12134",
//    "sender": "짱구",
//    "senderUuid": "user-uuid",
//    "msg": "채팅 내용",
//    "imgUrl": "https://firebasestorage.googleapis.com/v0/b/tht-android-a954a.appspot.com/o/1736064955156_1?alt=media&token=2224203d-1ebe-4586-92a6-5ba248a02f18",
//    "dateTime": "2023-11-13T17:30:12.000001234"
//  },
//  {
//    "chatIdx": "65f2d551d53ce4293c55dff1",
//    "sender": "신사임당",
//    "senderUuid": "46d960f565-2ae2-4193-96fd-31b6a8757611",
//    "msg": "안녕하세요~~2233",
//    "imgUrl": "https://firebasestorage.googleapis.com/v0/b/tht-android-a954a.appspot.com/o/1736064955156_1?alt=media&token=2224203d-1ebe-4586-92a6-5ba248a02f18",
//    "dateTime": "2024-03-14T19:45:37.311199135"
//  },
//  {
//    "chatIdx": "65f2d551d53ce4293c55dff2",
//    "sender": "신사임당",
//    "senderUuid": "46d960f565-2ae2-4193-96fd-31b6a8757611",
//    "msg": "안녕하세요~~2233",
//    "imgUrl": "https://firebasestorage.googleapis.com/v0/b/tht-android-a954a.appspot.com/o/1736064955156_1?alt=media&token=2224203d-1ebe-4586-92a6-5ba248a02f18",
//    "dateTime": "2024-03-14T19:45:37.311199135"
//  },
//  {
//    "chatIdx": "65f2d551d53ce4293c55dff3",
//    "sender": "신사임당",
//    "senderUuid": "46d960f565-2ae2-4193-96fd-31b6a8757611",
//    "msg": "안녕하세요~~2233",
//    "imgUrl": "https://firebasestorage.googleapis.com/v0/b/tht-android-a954a.appspot.com/o/1736064955156_1?alt=media&token=2224203d-1ebe-4586-92a6-5ba248a02f18",
//    "dateTime": "2024-03-14T19:45:37.311199135"
//  },
//  {
//    "chatIdx": "65f2d551d53ce4293c55dff4",
//    "sender": "신사임당",
//    "senderUuid": "46d960f565-2ae2-4193-96fd-31b6a8757611",
//    "msg": "안녕하세요~~2233",
//    "imgUrl": "https://firebasestorage.googleapis.com/v0/b/tht-android-a954a.appspot.com/o/1736064955156_1?alt=media&token=2224203d-1ebe-4586-92a6-5ba248a02f18",
//    "dateTime": "2024-03-14T19:45:37.311199135"
//  },
//]
//""".utf8)
    }
  }
}
