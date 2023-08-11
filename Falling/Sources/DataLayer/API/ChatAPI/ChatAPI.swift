//
//  ChatAPI.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import Foundation

import RxSwift
import RxMoya
import Moya

final class ChatAPI: Networkable {
  static let moya = makeProvider()
  typealias Target = ChatTarget

  static func rooms() -> Single<RoomsResponse> {
    return moya.rx
      .request(.rooms)
      .map(RoomsResponse.self)
  }

  static func room(id: String) -> Single<RoomResponse> {
    return moya.rx
      .request(.room(id: id))
      .map(RoomResponse.self)
  }

  static func histories(request: HistoryRequest) -> Single<HistoriesResponse> {
    return moya.rx
      .request(.history(request: request))
      .map(HistoriesResponse.self)
  }
}

