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
  func send(destination: String, sender: ChatRoomInfo.Participant, message: String, receiptID: String, header: [String: String])
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

  func send(destination: String, sender: ChatRoomInfo.Participant, message: String) {
    send(destination: destination, sender: sender, message: message, receiptID: UUID().uuidString, header: [:])
  }
}
