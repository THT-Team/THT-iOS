//
//  FallingTarget.swift
//  Falling
//
//  Created by Kanghos on 2023/10/09.
//

import Foundation

import Moya

enum FallingTarget {
  case talkKeyword
  case dailyKeyword
  case choiceTopic(Int)
  case users(DailyFallingUserRequest)
}

extension FallingTarget: BaseTargetType {

  var path: String {
    switch self {
    case .talkKeyword:
      return "all/talk-keyword"
    case .dailyKeyword:
      return "falling/daily-keyword"
    case .choiceTopic(let dailyFallingIndex):
      return "falling/choice/daily-keyword/\(dailyFallingIndex)"
    case .users:
      return "main/daily-falling/users"
    }
  }

  var method: Moya.Method {
    switch self {
    case .choiceTopic, .users: return .post
    default: return .get
    }
  }

  var sampleData: Data {
    switch self {
    case .users:
      return Data(
        """
        {
          "selectDailyFallingIdx": 123,
          "topicExpirationUnixTime": 1451021213,
          "userInfos": [
            {
              "username": "매칭된 유저 이름1",
              "userUuid": "매칭된 유저 uuid",
              "age": 24,
              "address": "인천광역시 부평구 ",
              "isBirthDay": true,
              "idealTypeResponseList": [
                {
                  "idx": 1,
                  "name": "자극을 주는",
                  "emojiCode": "1F4DA"
                },
                {
                  "idx": 2,
                  "name": "피부가 좋은",
                  "emojiCode": "1F3AC"
                },
                {
                  "idx": 3,
                  "name": "집순이/집돌이",
                  "emojiCode": "1F3B5"
                }
              ],
              "interestResponses": [
                {
                  "idx": 1,
                  "name": "등산하기",
                  "emojiCode": "1F3A4"
                },
                {
                  "idx": 2,
                  "name": "영화/드라마",
                  "emojiCode": "1F642"
                },
                {
                  "idx": 3,
                  "name": "게임",
                  "emojiCode": "1F963"
                }
              ],
              "userProfilePhotos": [
                {
                  "url": "test1",
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
              ],
              "introduction": "유저 자기소개",
              "userDailyFallingCourserIdx": 1
            },
            {
              "username": "매칭된 유저 이름2",
              "userUuid": "매칭된 유저 uuid",
              "age": 24,
              "address": "인천광역시 부평구 ",
              "isBirthDay": true,
                            "idealTypeResponseList": [
                              {
                                "idx": 1,
                                "name": "자극을 주는",
                                "emojiCode": "1F4DA"
                              },
                              {
                                "idx": 2,
                                "name": "피부가 좋은",
                                "emojiCode": "1F3AC"
                              },
                              {
                                "idx": 3,
                                "name": "집순이/집돌이",
                                "emojiCode": "1F3B5"
                              }
                            ],
                            "interestResponses": [
                              {
                                "idx": 1,
                                "name": "등산하기",
                                "emojiCode": "1F3A4"
                              },
                              {
                                "idx": 2,
                                "name": "영화/드라마",
                                "emojiCode": "1F642"
                              },
                              {
                                "idx": 3,
                                "name": "게임",
                                "emojiCode": "1F963"
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
                            ],
              "introduction": "유저 자기소개",
              "userDailyFallingCourserIdx": 2
            },
            {
              "username": "매칭된 유저 이름3",
              "userUuid": "매칭된 유저 uuid",
              "age": 24,
              "address": "인천광역시 부평구 ",
              "isBirthDay": true,
              "idealTypeResponseList": [
                {
                  "idx": 1,
                  "name": "자극을 주는",
                  "emojiCode": "1F4DA"
                },
                {
                  "idx": 2,
                  "name": "피부가 좋은",
                  "emojiCode": "1F3AC"
                },
                {
                  "idx": 3,
                  "name": "집순이/집돌이",
                  "emojiCode": "1F3B5"
                }
              ],
              "interestResponses": [
                {
                  "idx": 1,
                  "name": "등산하기",
                  "emojiCode": "1F3A4"
                },
                {
                  "idx": 2,
                  "name": "영화/드라마",
                  "emojiCode": "1F642"
                },
                {
                  "idx": 3,
                  "name": "게임",
                  "emojiCode": "1F963"
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
              ],
              "introduction": "유저 자기소개",
              "userDailyFallingCourserIdx": 3
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


  // Request의 파라미터를 결정한다.
  var task: Task {
    switch self {
    case .users(let request):
      return .requestParameters(parameters: request.toDictionary(), encoding: JSONEncoding.default)
    default:
      return .requestPlain
    }
  }

}
