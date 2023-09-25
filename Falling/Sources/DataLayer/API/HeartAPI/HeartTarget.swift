//
//  HeartTarget.swift
//  Falling
//
//  Created by Kanghos on 2023/09/11.
//

import Foundation

import Moya

enum HeartTarget {
  case like(id: String, topic: Int)
  case list(request: HeartListRequest)
  case reject(request: HeartRejectRequest)
  case userInfo(id: String)

}

extension HeartTarget: BaseTargetType {

  var path: String {
    switch self {
    case .like(let id, let topic):
      return "i-like-you/\(id)/\(topic)"
    case .list:
      return "like/receives"
    case .reject:
      return "like/reject"
    case .userInfo(let id):
      return "user/another/\(id)"
    }
  }

  var method: Moya.Method {
    switch self {
    case .like, .reject: return .post
    default: return .get
    }
  }

  var sampleData: Data {
    switch self {
    case .list:
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
              "name": "멋진",
              "emojiCode": "#2425fa"
            }
          ],
          "interestsList": [
            {
              "idx": 1,
              "name": "등산",
              "emojiCode": "#123df3"
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
      //    case .like(let id, let topic):
      //
      //      <#code#>
      //    case .reject(let request):
      //      <#code#>
      //    case .userInfo(let id):
      //      <#code#>
      //    }
    }
  }


  // Request의 파라미터를 결정한다.
  var task: Task {
    switch self {
    case .list(let request):
      return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.queryString)
    case .reject(let request):
      return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.queryString)
//    case .like(id: <#T##String#>, topic: <#T##Int#>)
//    case .userInfo(let id):

    default:
      return .requestPlain
    }
  }

}
