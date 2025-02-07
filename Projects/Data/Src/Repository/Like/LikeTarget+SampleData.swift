       //
//  LikeTarget+SampleData.swift
//  Data
//
//  Created by Kanghos on 2024/01/04.
//

import Foundation

import Networks

import Moya

extension LikeTarget {
  public var sampleData: Data {
    switch self {
    case .list(let request):
      if request.lastLikeIdx == nil {
        return Data(
        """
    {
      "likeList": [
        {
          "dailyFallingIdx": 1,
          "likeIdx": 1,
          "topic": "행복",
          "issue": "무엇을 할때 행복한가요?",
          "userUuid": "user-uuid-1",
          "username": "유저1",
          "profileUrl": "profile-url",
          "age": 24,
          "address": "주소",
          "receivedTime": "2023-09-05 17:15:52"
        },
        {
          "dailyFallingIdx": 2,
          "likeIdx": 3,
          "topic": "취미",
          "issue": "침대에 누워있고 싶지 않으세요?",
          "userUuid": "user-uuid-2",
          "username": "유저2",
          "profileUrl": "profile-url",
          "age": 32,
          "address": "주소",
          "receivedTime": "2023-09-05 17:15:52"
        },
        {
          "dailyFallingIdx": 3,
          "likeIdx": 154,
          "topic": "평화",
          "issue": "돈많은 백수가 되고싶네요",
          "userUuid": "user-uuid-3",
          "username": "유저3",
          "profileUrl": "profile-url",
          "age": 64,
          "address": "주소",
          "receivedTime": "2023-09-05 17:15:52"
        },
        {
          "dailyFallingIdx": 2,
          "likeIdx": 893,
          "topic": "취미",
          "issue": "침대에 누워있고 싶지 않으세요?",
          "userUuid": "user-uuid-4",
          "username": "유저4",
          "profileUrl": "profile-url",
          "age": 27,
          "address": "주소",
          "receivedTime": "2023-09-05 17:15:52"
        },
        {
          "dailyFallingIdx": 2,
          "likeIdx": 891,
          "topic": "취미",
          "issue": "침대에 누워있고 싶지 않으세요?",
          "userUuid": "user-uuid-4",
          "username": "유저5",
          "profileUrl": "profile-url",
          "age": 27,
          "address": "주소",
          "receivedTime": "2023-09-05 17:15:52"
        },
        {
          "dailyFallingIdx": 2,
          "likeIdx": 88,
          "topic": "행복",
          "issue": "침대에 누워있고 싶지 않으세요?",
          "userUuid": "user-uuid-4",
          "username": "유저6",
          "profileUrl": "profile-url",
          "age": 27,
          "address": "주소",
          "receivedTime": "2023-09-05 17:15:52"
        }
      ],
      "size": 6,
      "lastFallingTopicIdx": 2,
      "lastLikeIdx": 893
    }
    """.utf8
        )
      } else {
        return Data(
          """
              {
                "likeList": [
                  {
                    "dailyFallingIdx": 1,
                    "likeIdx": 11,
                    "topic": "행복",
                    "issue": "무엇을 할때 행복한가요?",
                    "userUuid": "user-uuid-5",
                    "username": "유저1",
                    "profileUrl": "profile-url",
                    "age": 24,
                    "address": "주소",
                    "receivedTime": "2023-09-05 17:15:52"
                  },
                  {
                    "dailyFallingIdx": 2,
                    "likeIdx": 31,
                    "topic": "취미",
                    "issue": "침대에 누워있고 싶지 않으세요?",
                    "userUuid": "user-uuid-6",
                    "username": "유저2",
                    "profileUrl": "profile-url",
                    "age": 32,
                    "address": "주소",
                    "receivedTime": "2023-09-05 17:15:52"
                  },
                  {
                    "dailyFallingIdx": 3,
                    "likeIdx": 1541,
                    "topic": "평화",
                    "issue": "돈많은 백수가 되고싶네요",
                    "userUuid": "user-uuid-7",
                    "username": "유저3",
                    "profileUrl": "profile-url",
                    "age": 64,
                    "address": "주소",
                    "receivedTime": "2023-09-05 17:15:52"
                  },
                  {
                    "dailyFallingIdx": 2,
                    "likeIdx": 8931,
                    "topic": "취미",
                    "issue": "침대에 누워있고 싶지 않으세요?",
                    "userUuid": "user-uuid-8",
                    "username": "유저4",
                    "profileUrl": "profile-url",
                    "age": 27,
                    "address": "주소",
                    "receivedTime": "2023-09-05 17:15:52"
                  },
                  {
                    "dailyFallingIdx": 2,
                    "likeIdx": 8911,
                    "topic": "취미",
                    "issue": "침대에 누워있고 싶지 않으세요?",
                    "userUuid": "user-uuid-9",
                    "username": "유저5",
                    "profileUrl": "profile-url",
                    "age": 27,
                    "address": "주소",
                    "receivedTime": "2023-09-05 17:15:52"
                  },
                  {
                    "dailyFallingIdx": 2,
                    "likeIdx": 881,
                    "topic": "행복",
                    "issue": "침대에 누워있고 싶지 않으세요?",
                    "userUuid": "user-uuid-10",
                    "username": "유저6",
                    "profileUrl": "profile-url",
                    "age": 27,
                    "address": "주소",
                    "receivedTime": "2023-09-05 17:15:52"
                  }
                ],
                "size": 6,
                "lastFallingTopicIdx": 2,
                "lastLikeIdx": 893
              }
          """
          .utf8
          )
      }
    case .like:
      return Data(
        """
        {
          "isMatching": true,
          "chatRoomIdx": 34
        }
        """.utf8
      )
    case .userInfo:
      return Data(
        """
        {
          "username": "유저이름",
          "userUuid": "makeUuid-2mnk-41",
          "age": 345,
          "introduction": "내 나이는 서른마흔다섯",
          "address": "서울시 성동구 저쩌구 동작구",
          "phoneNumber": "01010041004",
          "email": "beenZino@naver.com",
          "idealTypeList": [
            {
              "idx": 1,
              "name": "자극을 주는",
              "emojiCode": "U+1F4DA"
            },
            {
              "idx": 2,
              "name": "피부가 좋은",
              "emojiCode": "U+1F3AC"
            },
            {
              "idx": 3,
              "name": "집순이/집돌이",
              "emojiCode": "U+1F3B5"
            }
          ],
          "interestsList": [
            {
              "idx": 1,
              "name": "등산하기",
              "emojiCode": "U+1F3A4"
            },
            {
              "idx": 2,
              "name": "영화/드라마",
              "emojiCode": "U+1F642"
            },
            {
              "idx": 3,
              "name": "게임",
              "emojiCode": "U+1F963"
            }
          ],
          "userProfilePhotos": [
            {
              "url": "https://firebasestorage.googleapis.com/v0/b/tht-falling.appspot.com/o/images%2Fprofile_example1.png?alt=media&token=dc28c0cd-98b2-4332-9660-35530283d77c",
              "priority": 1
            },
            {
              "url": "https://firebasestorage.googleapis.com/v0/b/tht-falling.appspot.com/o/images%2Fprofile_example2.png?alt=media&token=e19493ed-10ba-4784-bf94-f4b99af84161",
              "priority": 2
            },
            {
              "url": "https://firebasestorage.googleapis.com/v0/b/tht-falling.appspot.com/o/images%2Fprofile_example2.png?alt=media&token=e19493ed-10ba-4784-bf94-f4b99af84161",
              "priority": 3
            }
          ]
        }
        """.utf8
        )
    default:
      return Data(
    """
    """.utf8
      )
    }
  }
}
