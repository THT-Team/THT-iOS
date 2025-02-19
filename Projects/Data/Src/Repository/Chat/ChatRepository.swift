//
//  ChatRepository.swift
//  Data
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import Networks

import RxSwift
import RxMoya
import Moya
import Domain

public typealias ChatRepository = BaseRepository<ChatTarget>

extension ChatRepository: ChatRepositoryInterface {

  public func rooms() -> Single<[ChatRoom]> {
    request(type: ChatRoomsRes.self, target: .rooms)
      .map { $0.map { $0.toDomain() } }
  }

  public func room(_ roomIdx: String) -> Single<ChatRoomInfo> {
    request(type: ChatRoomInfo.Res.self, target: .room(roomIdx))
      .map(ChatRoomInfo.init)
  }

  public func history(roomIdx: String, chatIdx: String?, size: Int) -> Single<[ChatMessage]> {
    request(type: ChatMessagesRes.self, target: .history(roomNo: roomIdx, chatIdx: chatIdx, size: size))
      .map { res in
        res.map(ChatMessage.init)
      }
  }

  public func out(_ roomIdx: String) -> Single<Void> {
    requestWithNoContent(target: .out(roomIdx))
  }
}
