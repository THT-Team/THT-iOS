//
//  UserTarget.swift
//  Falling
//
//  Created by Kanghos on 2023/07/10.
//

import Moya
import Foundation

enum ChatTarget {
  case history(request: HistoryRequest)
  case rooms
  case room(id: String)
  case exit(id: String)
}

extension ChatTarget: BaseTargetType {

  var path: String {
    switch self {
    case .history:
      return "chat/history"
    case .rooms:
      return "chat/rooms"
    case .room(let id):
      return "chat/rooms/\(id)"
    case .exit(let id):
      return "chat/out/room/\(id)"
    }
  }

  var method: Moya.Method {
    switch self {
    case .exit:
      return .post
    default:
      return .get
    }
  }

  // Request의 파라미터를 결정한다.
  var task: Task {
    switch self {
    case .history(let request):
      return .requestParameters(parameters: request.toDictionary(),
                                encoding: JSONEncoding.default)
    default:
      return .requestPlain
    }
  }

}
