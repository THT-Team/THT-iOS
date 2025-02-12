//
//  ChatServiceType.swift
//  Domain
//
//  Created by Kanghos on 1/20/25.
//

import Combine

import Core
import RxSwift

public protocol TalkUseCaseInterface {
  func connect()
  func disconnect()
  func subscribe(topic: String)
  func unsubscribe(topic: String)
  func send(destination: String, message: String, participant: [ChatRoomInfo.Participant])
  func listen() -> Observable<ChatSignalType>
  func bind()
}

public final class DefaultTalkUseCase: TalkUseCaseInterface {
  private var cancellable = Set<AnyCancellable>()
  private let messagePublisher = RxSwift.PublishSubject<ChatSignalType>()
  private let client: SocketInterface
  private let userStore: UserDefaultRepository

  public init(socketInterface: SocketInterface, userStore: UserDefaultRepository) {
    self.client = socketInterface
    self.userStore = userStore
  }

  public func connect() {
    client.connect()
  }
  
  public func disconnect() {
    client.disconnect()
    cancellable.forEach { item in
      item.cancel()
    }
  }
  
  public func subscribe(topic: String) {
    client.subscribe(topic: topic)
  }

  public func unsubscribe(topic: String) {
    client.unsubscribe(topic: topic)
  }
  
  public func send(destination: String, message: String, participant: [ChatRoomInfo.Participant]) {
    guard let currentID = userStore.fetchModel(for: .token, type: Token.self)?.userUuid,
          let currentUser = participant.first(where: { $0.id == currentID }) else {
      return
    }
    client.send(destination: destination, message: ChatMessage.Request(participant: currentUser, message: message))
  }

  public func listen() -> RxSwift.Observable<ChatSignalType> {
    messagePublisher.asObservable()
  }

  public func bind() {
    client.bind()

    client.listen()
      .sink(receiveValue: { [weak self] signal in
        self?.messagePublisher.onNext(signal)
      })
      .store(in: &cancellable)
  }
}
