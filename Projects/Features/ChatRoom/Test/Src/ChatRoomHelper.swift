//
//  ChatRoomHelper.swift
//  ChatRoomTest
//
//  Created by kangho lee on 6/15/25.
//

import Foundation

let messageSample = Data("""
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
        "dateTime": "2025-06-15T15:14:56.306069"
      },
      {
        "chatIdx": "1008objectIDc7de1b",
        "sender": "짱구",
        "senderUuid": "55bc01ac-b7ef-48e2-b9eb-5dd06e251832",
        "msg": "메시지 내용 9",
        "imgUrl": "https://example.com/image9.jpg",
        "dateTime": "2025-06-15T16:55:07.306069"
      },
      {
        "chatIdx": "1009objectIDc2272e",
        "sender": "철수",
        "senderUuid": "368d8bac-f558-4e2b-8501-5f46550b525f",
        "msg": "메시지 내용 10",
        "imgUrl": "https://example.com/image10.jpg",
        "dateTime": "2025-06-15T17:29:59.306069"
      }
    ]
""".utf8)
