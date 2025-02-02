//
//  ChatUseCaseInterface.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import RxSwift

public protocol ChatUseCaseInterface {
  func rooms() -> Observable<[ChatRoom]>
  func history(roomIdx: String, chatIdx: String?, size: Int) -> Observable<[ChatMessage]>
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
  
  public func history(roomIdx: String, chatIdx: String?, size: Int) -> RxSwift.Observable<[ChatMessage]> {
    repository.history(roomIdx: roomIdx, chatIdx: chatIdx, size: size)
      .asObservable()
  }
  
  public func room(_ roomIdx: String) -> RxSwift.Observable<ChatRoomInfo> {
    repository.room(roomIdx)
      .asObservable()
  }
  
  public func out(_ roomIdx: String) -> RxSwift.Observable<Void> {
    repository.out(roomIdx)
      .asObservable()
  }
}
