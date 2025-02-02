//
//  ChatRepositoryInterface.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import RxSwift

public protocol ChatRepositoryInterface {
  func rooms() -> Single<[ChatRoom]>
  func history(roomIdx: String, chatIdx: String?, size: Int) -> Single<[ChatMessage]>
  func room(_ roomIdx: String) -> Single<ChatRoomInfo>
  func out(_ roomIdx: String) -> Single<Void>
}
