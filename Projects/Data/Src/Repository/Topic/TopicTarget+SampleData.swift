//
//  TopicTarget+SampleData.swift
//  Data
//
//  Created by Kanghos on 1/6/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation

import Moya
import Domain

extension TopicTarget {
  public var sampleData: Data {
    switch self {
    case .talkKeyword:
      return Data("""
[
  {
    "idx": 1,
    "keyword": "talk keyword",
    "keywordImgIdx": 2
  },
  {
    "idx": 1,
    "keyword": "talk keyword",
    "keywordImgIdx": 2
  },
  {
    "idx": 1,
    "keyword": "talk keyword",
    "keywordImgIdx": 2
  }
]
""".utf8)
    case .checkDailyTopic:
      return Data("""
{
  "isChoose": true
}
""".utf8)
    case .dailyKeyword:
      return Data("""
{
  "expirationUnixTime": 1687744800,
  "type": "oneChoice",
  "introduction": "오늘 나는 너랑..",
  "fallingTopicList": [
    {
      "idx": 112304,
      "keyword": "키워드",
      "keywordIdx": 3,
      "keywordImgUrl": "카워드-이미지-url",
      "talkIssue": "키워드 파생질문 - 이런이런 주제로 이야기해볼까요~"
    }
  ]
}
""".utf8)
    case .choice(let string):
      return Data()
    }
  }
}
