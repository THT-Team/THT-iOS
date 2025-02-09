//
//  ChatServiceType.swift
//  Domain
//
//  Created by Kanghos on 1/20/25.
//

import Combine

import Core
import RxSwift
//import SwiftStomp

public protocol TalkUseCaseInterface {
  func connect()
  func disconnect()
  func subscribe(topic: String)
  func unsubscribe(topic: String)
  func send(destination: String, message: ChatMessage.Request)
  func listen() -> Observable<ChatSignalType>
  func bind()
}

public final class DefaultTalkUseCase: TalkUseCaseInterface {
  private var cancellable = Set<AnyCancellable>()
  private let messagePublisher = RxSwift.PublishSubject<ChatSignalType>()
  private let client: SocketInterface

  public init(socketInterface: SocketInterface) {
    self.client = socketInterface
  }

  public func connect() {
    client.connect()
  }
  
  public func disconnect() {
    client.disconnect()
  }
  
  public func subscribe(topic: String) {
    client.subscribe(topic: topic)
  }
  
  public func unsubscribe(topic: String) {
    client.unsubscribe(topic: topic)
  }
  
  public func send(destination: String, message: ChatMessage.Request) {
    client.send(destination: destination, message: message)
  }

  public func listen() -> RxSwift.Observable<ChatSignalType> {
    messagePublisher.asObservable()
  }

  public func bind() {
    client.bind()
  }
}
