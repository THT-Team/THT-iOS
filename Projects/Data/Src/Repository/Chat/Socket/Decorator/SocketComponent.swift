//
//  SocketDecorator.swift
//  Domain
//
//  Created by Kanghos on 2/8/25.
//

import UIKit
import Combine

import SwiftStomp
import Core

import Domain
import Networks

public class SocketComponent: SocketInterface {
  private let publisher = PassthroughSubject<ChatSignalType, Never>()
  private var client: SwiftStomp
  private var cancellable: Set<AnyCancellable> = []
  public init(config: ChatConfiguration) {
    self.client = SwiftStomp(
      host: config.hostURL,
      headers: config.connectHeader)
    self.client.autoReconnect = config.autoReconnect
    self.client.enableLogging = true
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
      cancellable.forEach { $0.cancel() }
    }
  }
  public func subscribe(topic: String, header: [String : String]) {
    client.subscribe(to: topic, mode: .client)
  }

  public func unsubscribe(topic: String, header: [String : String]) {
    client.unsubscribe(from: topic)
  }

  public func send(destination: String, sender: ChatRoomInfo.Participant, message: String, receiptID: String, header: [String : String]) {
    client.send(
      body: ChatMessage.Request(participant: sender, message: message),
      to: destination,
      receiptId: receiptID,
      headers: header)
  }

  public func listen() -> AnyPublisher<ChatSignalType, Never> {
    publisher.eraseToAnyPublisher()
  }

  public func bind() {

    client.messagesUpstream
      .compactMap(StompMessageMapper.message(_:))
      .subscribe(publisher)
      .store(in: &cancellable)

    client.receiptUpstream
      .map(ChatSignalType.receipt(_:))
      .subscribe(publisher)
      .store(in: &cancellable)

    client.eventsUpstream
      .compactMap(StompMessageMapper.event(_:))
      .subscribe(publisher)
      .store(in: &cancellable)
  }

  public func replace(_ config: ChatConfiguration, header: [String : String]) {
    self.client = SwiftStomp(host: config.hostURL, headers: header)
  }
}

struct StompMessageMapper {
  static func message(_ message: StompUpstreamMessage) -> ChatSignalType? {
    switch message {
    case let .data(data, _, _, _):
      return transform(data)
    case let .text(text, _, _, _):
      return transform(Data(text.utf8))
    }
  }

  private static func transform(_ data: Data) -> ChatSignalType? {
    guard
      let response = try? JSONDecoder.customDeocder .decode(ChatMessage.Response.self, from: data)
    else {
      return nil
    }
    return .message(ChatMessage(response))
  }

  static func event(_ event: StompUpstreamEvent) -> ChatSignalType? {
    switch event {
    case let .connected(type):
      return type == .toStomp ? .stompConnected : nil
    case let .disconnected(type):
      return type == .fromStomp ? .stompDisconnected : nil
    case let .error(error):
      return error.description.contains("UNAUTHORIZED")
      ? .needAuth : nil
    }
  }
}
