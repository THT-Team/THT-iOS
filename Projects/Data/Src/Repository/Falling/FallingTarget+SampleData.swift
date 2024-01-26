//
//  FallingTarget+SampleData.swift
//  Data
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

extension FallingTarget {
  public var sampleData: Data {
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
                  "url": "https://cdn.pixabay.com/photo/2024/01/15/21/16/dog-8510901_640.jpg",
                  "priority": 1
                },
                {
                  "url": "https://firebasestorage.googleapis.com/v0/b/tht-falling.appspot.com/o/images%2Fprofile_example1.png?alt=media&token=dc28c0cd-98b2-4332-9660-35530283d77c",
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
                                "url": "https://cdn.pixabay.com/photo/2023/05/07/11/57/surfboard-7976219_960_720.jpg",
                                "priority": 1
                              },
                              {
                                "url": "https://cdn.pixabay.com/photo/2024/01/07/11/17/welsh-corgi-8492879_640.jpg",
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
                  "url": "https://cdn.pixabay.com/photo/2023/03/18/05/26/ferris-wheel-7859855_640.jpg",
                  "priority": 1
                },
                {
                  "url": "https://cdn.pixabay.com/photo/2023/11/17/12/46/cat-8394224_640.jpg",
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
}
