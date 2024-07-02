//
//  UserDomainTarget+Sample.swift
//  Data
//
//  Created by Kanghos on 7/27/24.
//

import Foundation

import Networks
import Moya

extension UserDomainTarget {
  public var sampleData: Data {
    switch self {

    case .interests:
      return Data("""
      [
        {
          "idx": 1,
          "name": "게임",
          "emojiCode": "U+1F3AE"
        },
        {
          "idx": 2,
          "name": "독서",
          "emojiCode": "U+1F4DA"
        },
        {
          "idx": 3,
          "name": "영화/드라마",
          "emojiCode": "U+1F3AC"
        },
        {
          "idx": 4,
          "name": "언어공부",
          "emojiCode": "U+1F1F0"
        },
        {
          "idx": 5,
          "name": "음악",
          "emojiCode": "U+1F3B6"
        },
        {
          "idx": 6,
          "name": "넷플릭스",
          "emojiCode": "U+1F4F1"
        },
        {
          "idx": 7,
          "name": "전시 관람",
          "emojiCode": "U+1F4F8"
        },
        {
          "idx": 8,
          "name": "철학",
          "emojiCode": "U+1F3DB"
        },
        {
          "idx": 9,
          "name": "스포츠",
          "emojiCode": "U+26BD"
        },
        {
          "idx": 10,
          "name": "산책하기",
          "emojiCode": "U+1F331"
        },
        {
          "idx": 11,
          "name": "글쓰기",
          "emojiCode": "U+1F3FB"
        },
        {
          "idx": 12,
          "name": "운동하기",
          "emojiCode": "U+1F4AA"
        },
        {
          "idx": 13,
          "name": "그림 그리기",
          "emojiCode": "U+1F3A8"
        },
        {
          "idx": 14,
          "name": "반려동물",
          "emojiCode": "U+1F43C"
        },
        {
          "idx": 15,
          "name": "패션",
          "emojiCode": "U+1F457"
        },
        {
          "idx": 16,
          "name": "사람 만나기",
          "emojiCode": "U+1F457"
        },
        {
          "idx": 17,
          "name": "재테크/파이낸스",
          "emojiCode": "U+1F4B0"
        },
        {
          "idx": 18,
          "name": "뷰티",
          "emojiCode": "U+1F484"
        },
        {
          "idx": 19,
          "name": "K-Pop",
          "emojiCode": "U+1F3A4"
        },
        {
          "idx": 20,
          "name": "맛집찾기",
          "emojiCode": "U+1F963"
        }
      ]
      """.utf8)

    case .idealTypes:
      return Data("""
    [
      {
        "idx": 1,
        "name": "지적인",
        "emojiCode": "U+1F9E0"
      },
      {
        "idx": 2,
        "name": "귀여운",
        "emojiCode": "U+1F63B"
      },
      {
        "idx": 3,
        "name": "피부가 좋은",
        "emojiCode": "U+2728"
      },
      {
        "idx": 5,
        "name": "자극을 주는",
        "emojiCode": "U+1F525"
      },
      {
        "idx": 6,
        "name": "시크한",
        "emojiCode": "U+1F60E"
      },
      {
        "idx": 7,
        "name": "건강미",
        "emojiCode": "U+1F4AA"
      },
      {
        "idx": 8,
        "name": "웃는게 이쁜",
        "emojiCode": "U+FE0F"
      },
      {
        "idx": 9,
        "name": "세심한",
        "emojiCode": "U+FE0F"
      },
      {
        "idx": 10,
        "name": "유머러스한",
        "emojiCode": "U+1F602"
      },
      {
        "idx": 11,
        "name": "고양이상",
        "emojiCode": "U+1F431"
      },
      {
        "idx": 12,
        "name": "멍멍이상",
        "emojiCode": "U+1F436"
      },
      {
        "idx": 13,
        "name": "활발한",
        "emojiCode": "U+1F606"
      },
      {
        "idx": 14,
        "name": "열심히 사는",
        "emojiCode": "U+1F44D"
      },
      {
        "idx": 15,
        "name": "적극적인",
        "emojiCode": "U+1F609"
      },
      {
        "idx": 16,
        "name": "진지한",
        "emojiCode": "U+1F928"
      },
      {
        "idx": 17,
        "name": "집돌이/집순이",
        "emojiCode": "U+1F3E0"
      },
      {
        "idx": 18,
        "name": "리드를 해주는",
        "emojiCode": "U+1F44B"
      },
      {
        "idx": 19,
        "name": "연락이 잘 되는",
        "emojiCode": "U+1F4AC"
      },
      {
        "idx": 20,
        "name": "자유로운",
        "emojiCode": "U+1F917"
      },
      {
        "idx": 21,
        "name": "다정한",
        "emojiCode": "U+1F607"
      }
    ]
    """.utf8)
    }
  }
}
