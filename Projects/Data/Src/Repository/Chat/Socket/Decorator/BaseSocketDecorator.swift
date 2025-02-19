//
//  BaseSocketDecorator.swift
//  Domain
//
//  Created by Kanghos on 2/8/25.
//

import Foundation
import Combine

import Domain

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

  public func subscribe(topic: String, header: [String : String]) {
    wrappee.subscribe(topic: topic, header: header)
  }

  public func unsubscribe(topic: String, header: [String : String]) {
    wrappee.unsubscribe(topic: topic, header: header)
  }

  public func send(destination: String, sender: ChatRoomInfo.Participant, message: String, receiptID: String, header: [String : String]) {
    wrappee.send(destination: destination, sender: sender, message: message, receiptID: receiptID, header: header)
  }

  public func listen() -> AnyPublisher<ChatSignalType, Never> {
    wrappee.listen()
  }

  public func bind() {
    wrappee.bind()
  }

  public func replace(_ config: ChatConfiguration, header: [String : String]) {
    wrappee.replace(config, header: header)
  }
}
