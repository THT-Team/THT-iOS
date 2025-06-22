//
//  MockTalkUseCase.swift
//  ChatRoom
//
//  Created by Kanghos on 1/25/25.
//
import Foundation

import Core

public final class MockTalkUseCase: @preconcurrency TalkUseCaseInterface {
  private let messagePublisher = RxSwift.PublishSubject<MessageType>()
  private static var chatIndex = 0
  private var disposeBag = DisposeBag()

  public init() {
    bind()
  }

  public func connect() {
    messagePublisher.onNext(.connected)
  }
  
  public func disconnect() {

  }
  
  public func subscribe(topic: String) {
    
  }
  
  public func unsubscribe(topic: String) {

  }

  @MainActor
  public func send(destination: String, message: String, participant: [ChatRoomInfo.Participant]) {
    messagePublisher.onNext(.message(.outgoing(Self.makeChatMessage(name: "me", message: message))))

    let sender = Int.random(in: (1...30)).isMultiple(of: 2)
    Task {
      try? await Task.sleep(nanoseconds: 300)
      messagePublisher.onNext(.message(
        sender
        ? .incoming(Self.makeChatMessage(name: "echo", message: message))
        : .outgoing(Self.makeChatMessage(name: "me", message: message))))
    }
  }
  
  public func send(destination: String, text: String) {

  }
  
  public func listen() -> RxSwift.Observable<Domain.MessageType> {
    messagePublisher.asObservable()
  }

  public func bind() {
  }

  private static func makeChatMessage(name: String, message: String) -> ChatMessage {
    chatIndex += 1
    let user = ChatRoomInfo.Participant(id: "asdf", name: name, profileURL: "https://firebasestorage.googleapis.com/v0/b/tht-android-a954a.appspot.com/o/1736064955156_1?alt=media&token=2224203d-1ebe-4586-92a6-5ba248a02f18")
    return ChatMessage(chatIndex, user: user, message: message)
  }
}

fileprivate extension ChatMessage {
  init(_ id: Int, user: ChatRoomInfo.Participant, message: String) {
    self.init(chatIdx: String(id), sender: user.name, senderUuid: user.id, msg: message, imgUrl: user.profileURL, dataTime: Date())
  }

  static func echo(_ message: ChatMessage, id: Int) -> ChatMessage {
    self.init(id, user: .init(id: message.senderUuid + "echo", name: "echo", profileURL: message.imgUrl), message: message.msg)
  }
}
