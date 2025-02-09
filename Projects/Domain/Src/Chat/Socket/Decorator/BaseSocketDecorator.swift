//
//  BaseSocketDecorator.swift
//  Domain
//
//  Created by Kanghos on 2/8/25.
//

import Foundation
import Combine

public class BaseSocketDecorator: SocketInterface {

  private let wrappee: SocketInterface

  public init(_ wrappee: SocketInterface) {
    self.wrappee = wrappee
  }

  public func connect() {
    wrappee.connect()
  }

  public func disconnect() {
    wrappee.disconnect()
  }

  public func subscribe(topic: String) {
    wrappee.subscribe(topic: topic)
  }

  public func unsubscribe(topic: String) {
    wrappee.unsubscribe(topic: topic)
  }

  public func send(destination: String, message: ChatMessage.Request) {
    wrappee.send(destination: destination, message: message)
  }

  public func listen() -> AnyPublisher<ChatSignalType, Never> {
    wrappee.listen()
  }

  public func bind() {
    wrappee.bind()
  }
}
