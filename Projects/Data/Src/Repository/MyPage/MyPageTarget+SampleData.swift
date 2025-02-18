//
//  MyPageTarget+SampleData.swift
//  Data
//
//  Created by Kanghos on 6/6/24.
//

import Foundation

import Networks

import Moya

extension MyPageTarget {
  public var sampleData: Data {
    switch self {

    case .updateUserContacts, .fetchUserContacts:
      return Data("""
      {
        "count": 1
      }
      """.utf8)

    case .user:
      return Data("""
      {
        "prefer_gender": "FEMALE",
        "username": "ibcylon",
        "userUuid": "397d42f24a-b7a0-4bc3-8bc7-da8d18f56376",
        "age": 21,
        "introduction": "SksmsandjdfRKfjalsfjld\\nafdjasldfdy",
        "address": "서울 영등포구 문래동",
        "phoneNumber": "01089192466",
        "email": "ibcylon@naver.com",
        "gender": "MALE",
        "tall": 145,
        "smoking": "NONE",
      "birthDay": "2025-01-30",
        "drinking": "FREQUENTLY",
        "religion": "BUDDHISM",
        "idealTypeList": [
          {
            "idx": 13,
            "name": "활발한",
            "emojiCode": "U+1F606"
          },
          {
            "idx": 15,
            "name": "적극적인",
            "emojiCode": "U+1F609"
          },
          {
            "idx": 17,
            "name": "말이 통하는",
            "emojiCode": "U+1F4AC"
          }
        ],
        "interestsList": [
          {
            "idx": 1,
            "name": "게임",
            "emojiCode": "U+1F3AE"
          },
          {
            "idx": 4,
            "name": "언어공부",
            "emojiCode": "U+1F1F0"
          },
          {
            "idx": 7,
            "name": "전시 관람",
            "emojiCode": "U+1F4F8"
          }
        ],
        "userProfilePhotos": [
          {
            "url": "test.jpg",
            "priority": 1
          },
          {
            "url": "test2.jpg",
            "priority": 2
          }
        ],
        "userAgreements": {
          "serviceUseAgree": true,
          "personalPrivacyInfoAgree": true,
          "locationServiceAgree": false,
          "marketingAgree": true
        }
      }
      """.utf8)
    case .updateAlarmSetting: return Data("".utf8)
    case .location(_): return Data("".utf8)
    case .withdrawal: return Data("".utf8)
    default: return Data("".utf8)
    }
  }
}
