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
  func listen() -> Observable<MessageType>
  func bind()
}

public final class DefaultTalkUseCase: TalkUseCaseInterface {
  private var cancellable = Set<AnyCancellable>()
  private let messagePublisher = RxSwift.PublishSubject<MessageType>()
  private let client: SocketInterface
  private let tokenService: TokenServiceType

  public init(socketInterface: SocketInterface, tokenService: TokenServiceType) {
    self.client = socketInterface
    self.tokenService = tokenService
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
    guard let currentID = tokenService.getToken()?.userUuid,
          let currentUser = participant.first(where: { $0.id == currentID }) else {
      return
    }
    client.send(destination: destination, sender: currentUser, message: message)
  }

  public func listen() -> RxSwift.Observable<MessageType> {
    messagePublisher.asObservable()
  }

  public func bind() {
    client.bind()

    client.listen()
      .sink(receiveValue: { [weak self] signal in
        switch signal {
        case .message(let content):
          if self?.tokenService.getToken()?.userUuid == content.senderUuid {
            self?.messagePublisher.onNext(.message(.outgoing(content)))
          } else {
            self?.messagePublisher.onNext(.message(.incoming(content)))
          }
        case .stompConnected:
          self?.messagePublisher.onNext(.connected)
        case .stompDisconnected:
          self?.messagePublisher.onNext(.disconnected)
        case .needAuth: return
        case .receipt: return
        }
      })
      .store(in: &cancellable)
  }
}
