//
//  ChatServiceType.swift
//  Domain
//
//  Created by Kanghos on 1/20/25.
//

import Foundation
import RxSwift
import SwiftStomp
import Combine
import UIKit

public protocol TalkUseCaseInterface {
  func connect()
  func disconnect()
  func subscribe(topic: String)
  func unsubscribe(topic: String)
  func send(destination: String, message: ChatMessage.Request)
  func send(destination: String, text: String)
  func listen() -> Observable<ChatSignalType>
}

public final class DefaultTalkUseCase: TalkUseCaseInterface {
  private let client: SwiftStomp
  private var cancellable = Set<AnyCancellable>()
  private let messagePublisher = RxSwift.PublishSubject<ChatSignalType>()

  public init(config: ChatConfiguration = ChatConfiguration()) {
    self.client = SwiftStomp(host: config.hostURL, headers: [
      "Authorization": ""
    ])
    
    bind()
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
    client.send(body: message, to: destination, receiptId: "asldjf", headers: [
      "Authorization": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhdXRob3JpemF0aW9uIiwidXNlclV1aWQiOiI0NmQ5NjBmNTY1LTJhZTItNDE5My05NmZkLTMxYjZhODc1NzYxMSIsInJvbGUiOiJOT1JNQUwiLCJleHAiOjQ4NjQwMDQxODZ9.VGC6EJmCBdevtfSQspqsdu42FFl25dSBSHvHue6mAhE"
    ])
  }

  public func send(destination: String, text: String) {
    client.send(body: text, to: destination)
  }

  public func listen() -> RxSwift.Observable<ChatSignalType> {
    messagePublisher.asObservable()
  }

  // TODO: App Life Cycle과 Message Stream 분리해서 UseCase만들기
  private func bind() {
    NotificationCenter.default.publisher(for: UIScene.didActivateNotification)
      .sink { [weak self] _ in
        self?.connect()
      }.store(in: &cancellable)

    NotificationCenter.default.publisher(for: UIScene.didEnterBackgroundNotification)
      .sink { [weak self] _ in
        self?.disconnect()
      }.store(in: &cancellable)

    client.messagesUpstream
      .sink { [weak self] message in
        switch message {
        case let .data(data, _, _, _):
          // TODO: Move Decoding Logic to Data Layer
          guard let chatMessage = try? JSONDecoder().decode(ChatMessage.Response.self, from: data) else {
            return
          }
          self?.messagePublisher.onNext(.message(chatMessage.toDomain()))
        case let .text(message, _, _, _):
          print(message)
        }
      }.store(in: &cancellable)

    client.receiptUpstream
      .sink { [weak self] id in
        print("id: \(id)")
        self?.messagePublisher.onNext(.receipt(id))
      }
      .store(in: &cancellable)

    client.eventsUpstream
      .sink { [weak self] event in
        switch event {
        case let .connected(type):
          print("CONNECTED: ", type)
          if type == .toStomp {
            self?.messagePublisher.onNext(.stompConnected)
          }
        case let .disconnected(type):
          print("DISCONNECTED: ", type)
        case let .error(error):
          print("ERROR: \(error.description)")
        }
      }
      .store(in: &cancellable)
  }
}
