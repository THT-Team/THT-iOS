//
//  MockTalkUseCase.swift
//  ChatRoom
//
//  Created by Kanghos on 1/25/25.
//
import Foundation

import Domain
import Core

public final class MockTalkUseCase: @preconcurrency TalkUseCaseInterface {
  private let messagePublisher = RxSwift.PublishSubject<ChatSignalType>()
  private let echoRelay = PublishRelay<ChatSignalType>()
  private var chatIndex = 0
  private var disposeBag = DisposeBag()

  public init() {
    bind()
  }

  public func connect() {
    messagePublisher.onNext(.stompConnected)
  }
  
  public func disconnect() {

  }
  
  public func subscribe(topic: String) {
    
  }
  
  public func unsubscribe(topic: String) {

  }

  @MainActor
  public func send(destination: String, message: Domain.ChatMessage.Request) {
    chatIndex += 1
    let domain = ChatMessage(chatIdx: String(chatIndex), sender: message.sender, senderUuid: message.senderUUID, msg: message.message, imgUrl: message.imageURL, dataTime: Date())
    chatIndex += 1
    let echo = ChatMessage(chatIdx: String(chatIndex), sender: "echo", senderUuid: message.senderUUID + "1", msg: message.message, imgUrl: message.imageURL, dataTime: Date())
    messagePublisher.onNext(.message(.outgoing(domain)))
    echoRelay.accept(.message(.incoming(echo)))
  }
  
  public func send(destination: String, text: String) {

  }
  
  public func listen() -> RxSwift.Observable<Domain.ChatSignalType> {
    messagePublisher.asObservable()
  }

  private func bind() {
    echoRelay
      .delay(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(messagePublisher)
      .disposed(by: disposeBag)
//    Observable<Int>
//      .timer(.seconds(0), period: .seconds(10), scheduler: MainScheduler.instance)
//      .withUnretained(self)
//      .map { owner, _ -> ChatSignalType in
//        owner.chatIndex += 1
//        return .message(ChatMessage(chatIdx: String(owner.chatIndex), sender: "echo", senderUuid: "echo", msg: "echo", imgUrl: "", dataTime: Date()))
//      }
//      .subscribe(messagePublisher)
//      .disposed(by: disposeBag)
  }
}
