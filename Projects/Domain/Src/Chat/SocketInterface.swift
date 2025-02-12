//
//  SocketInterface.swift
//  Domain
//
//  Created by Kanghos on 2/11/25.
//

import Foundation
import Combine

public protocol SocketInterface {
  func connect()
  func disconnect()
  func subscribe(topic: String, header: [String: String])
  func unsubscribe(topic: String, header: [String: String])
  func send<T: Encodable>(destination: String, message: T, header: [String: String])
  func listen() ->  AnyPublisher<ChatSignalType, Never>
  func bind()
  func replace(_ config: ChatConfiguration, header: [String: String])
}

extension SocketInterface {
  func subscribe(topic: String) {
    subscribe(topic: topic, header: [:])
  }

  func unsubscribe(topic: String) {
    unsubscribe(topic: topic, header: [:])
  }

  func send<T: Encodable>(destination: String, message: T) {
    send(destination: destination, message: message, header: [:])
  }
}
