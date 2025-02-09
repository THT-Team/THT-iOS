//
//  SocketDecorator.swift
//  Domain
//
//  Created by Kanghos on 2/8/25.
//

import Foundation
import Combine
import SwiftStomp
import Core
import UIKit

public protocol SocketInterface {
  func connect()
  func disconnect()
  func subscribe(topic: String)
  func unsubscribe(topic: String)
  func send(destination: String, message: ChatMessage.Request)
  func listen() ->  AnyPublisher<ChatSignalType, Never>
  func bind()
}

public class SocketComponent: SocketInterface {
  private let publisher = PassthroughSubject<ChatSignalType, Never>()
  private var client: SwiftStomp
  private var cancellable: Set<AnyCancellable> = []
  public init(config: ChatConfiguration) {
    self.client = SwiftStomp(
      host: config.hostURL,
      headers: [:])
  }

  deinit {
    TFLogger.cycle(name: self)
  }

  public func connect() {
    if !client.isConnected {
      client.connect()
    }
  }

  public func disconnect() {
    if client.isConnected {
      client.disconnect()
    }
  }
  public func subscribe(topic: String) {
    client.subscribe(to: topic, mode: .client)
  }

  public func unsubscribe(topic: String) {
    client.unsubscribe(from: topic)
  }

  public func send(destination: String, message: ChatMessage.Request) {
    client.send(
      body: message,
      to: destination,
      receiptId: UUID().uuidString
      )
  }

  public func listen() -> AnyPublisher<ChatSignalType, Never> {
    publisher.eraseToAnyPublisher()
  }

  public func bind() {
    bindLifeCycle()

    client.messagesUpstream
      .compactMap(StompMessageMapper.message(_:))
      .subscribe(publisher)
      .store(in: &cancellable)

    client.receiptUpstream
      .print()
      .map(ChatSignalType.receipt(_:))
      .subscribe(publisher)
      .store(in: &cancellable)

    client.eventsUpstream
      .print()
      .compactMap(StompMessageMapper.event(_:))
      .subscribe(publisher)
      .store(in: &cancellable)
  }

  private func bindLifeCycle() {
    // TODO: App Life Cycle과 Message Stream 분리해서 UseCase만들기
    NotificationCenter.default.publisher(for: UIScene.didActivateNotification)
      .sink { [weak self] _ in
        self?.connect()
      }.store(in: &cancellable)

    NotificationCenter.default.publisher(for: UIScene.didEnterBackgroundNotification)
      .sink { [weak self] _ in
        self?.disconnect()
      }.store(in: &cancellable)
  }
}

struct StompMessageMapper {
  // TODO: Move Decoding Logic to Data Layer
  static func message(_ message: StompUpstreamMessage) -> ChatSignalType? {
    switch message {
    case let .data(data, _, _, _):
      guard let response = try? JSONDecoder().decode(ChatMessage.Response.self, from: data) else {
        return nil
      }
      let chatMessage = ChatMessage(response)
      let currentUserUUID = UserDefaultRepository.shared.fetch(for: .currentUUID, type: String.self)
      let messageType: ChatMessageType =  chatMessage.senderUuid == currentUserUUID
      ? .outgoing(chatMessage) : .incoming(chatMessage)

      return .message(messageType)
    case let .text(message, _, _, _):
      print(message)
      return nil
    }
  }

  static func event(_ event: StompUpstreamEvent) -> ChatSignalType? {
    switch event {
    case let .connected(type):
      return type == .toStomp ? .stompConnected : nil
    case let .disconnected(type):
      return type == .fromStomp ? .stompDisconnected : nil
    case let .error(error):
      return error.description.contains("401")
      ? .needAuth : nil
    }
  }
}
