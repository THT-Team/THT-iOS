//
//  ChatUseCaseInterface.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation
import Core

import RxSwift

public protocol ChatUseCaseInterface {
  func rooms() -> Observable<[ChatRoom]>
  func history(roomIdx: String, chatIdx: String?, size: Int) -> Observable<[Date: [ChatMessageType]]>
  func room(_ roomIdx: String) -> Observable<ChatRoomInfo>
  func out(_ roomIdx: String) -> Observable<Void>
}

public final class DefaultChatUseCase {
  private let repository: ChatRepositoryInterface

  public init(repository: ChatRepositoryInterface) {
    self.repository = repository
  }
}

extension DefaultChatUseCase: ChatUseCaseInterface {
  public func rooms() -> RxSwift.Observable<[ChatRoom]> {
    repository.rooms()
      .asObservable()
  }
  
  public func history(roomIdx: String, chatIdx: String?, size: Int) -> RxSwift.Observable<[Date: [ChatMessageType]]> {
    let calender = Calendar.current
    return repository.history(roomIdx: roomIdx, chatIdx: chatIdx, size: size)
      .asObservable()
      .map { messages -> [ChatMessageType] in
        messages.map { message -> ChatMessageType in
          let userUUID = UserDefaultRepository.shared.fetchModel(for: .token, type: Token.self)?.userUuid
          return message.senderUuid == userUUID
          ? .outgoing(message) : .incoming(message)
        }
      }.map {
        Dictionary(grouping: $0) { messageType in
          calender.startOfDay(for: messageType.message.dateTime)
        }
      }
      .debug()
  }
  
  public func room(_ roomIdx: String) -> RxSwift.Observable<ChatRoomInfo> {
    let userUUID = UserDefaultRepository.shared.fetchModel(for: .token, type: Token.self)?.userUuid
    return repository.room(roomIdx)
      .asObservable()
      .map { info in
        var info = info
        info.title = info.participants
          .first { $0.id != userUUID }?.name
        return info
      }
  }
  
  public func out(_ roomIdx: String) -> RxSwift.Observable<Void> {
    repository.out(roomIdx)
      .asObservable()
  }
}
