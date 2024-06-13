//
//  SignUpTarget+SampleData.swift
//  Data
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

import Networks

import Moya

extension SignUpTarget {
  public var sampleData: Data {
    switch self {
    case .certificate:
      return Data(
        """
    {
      "phoneNumber": "01012345678",
      "authNumber": 123456
    }
    """.utf8)
    case .checkNickname:
      return Data(
        """
    {
      "isDuplicate": true
    }
    """.utf8)
    case .checkExistence:
      return Data(
        """
    {
      "isSignUp": false,
      "typeList": [
        "NORMAL",
        "KAKAO",
        "NAVER",
        "GOOGLE"
      ]
    }
    """.utf8)

    case .agreement:
      return Data(
      """
      [
        {
        "name":"serviceUseAgree","subject":"이용약관을 읽고, 이해했으며, 동의합니다.",
        "isRequired":true,
        "description":"",
        "detailLink":"https://www.notion.so/janechoi/526c51e9cb584f29a7c16251914bb3cb?pvs=4"
        },
        {
        "name":"personalPrivacyInfoAgree",
        "subject":"개인 정보 처리 방침을 읽고, 이해했으며, 동의합니다.",
        "isRequired":true,
        "description":"",
        "detailLink":"https://www.notion.so/janechoi/5923a3c20259459bbacaff41290fc615?pvs=4"
        },
        {
        "name":"marketingAgree","subject":"마케팅 정보 수신 동의",
        "isRequired":false,
        "description":"폴링에서 제공하는 이벤트/혜택 등 다양한 정보를 Push 알림으로 받아보실 수 있습니다.",
        "detailLink":""
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
