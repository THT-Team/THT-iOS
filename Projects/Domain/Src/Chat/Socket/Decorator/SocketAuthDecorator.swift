//
//  SocketAuthDecorator.swift
//  Domain
//
//  Created by Kanghos on 2/8/25.
//

import Foundation
import Combine
import Core

public final class SocketAuthDecorator: BaseSocketDecorator {
  var refreshCount = 2
  private let tokenRefresher: TokenRefresher
  private let tokenStore: TokenStore
  private let publisher = PassthroughSubject<ChatSignalType, Never>()
  private var cancellables: Set<AnyCancellable> = []

  public init(_ wrappee: SocketInterface, tokenRefresher: TokenRefresher, tokenStore: TokenStore) {
    self.tokenRefresher = tokenRefresher
    self.tokenStore = tokenStore
    super.init(wrappee)
  }

  func makeHeader(token: String) -> [String: String] {
    [
      "Authorization": "\(token)"
    ]
  }

  func refresh(token: Token) {
    Task {
      let refreshed = try await tokenRefresher.refresh(token)
    }
  }

  func initSocket(config: ChatConfiguration = .init(), header: [String: String]?) {
//    self.client = SwiftStomp(host: config.hostURL, headers: header)
  }

  public override func connect() {

    super.connect()
  }

  public override func disconnect() {
    super.disconnect()
  }

  public override func send(destination: String, message: ChatMessage.Request) {
    super.send(destination: destination, message: message)
  }

  public override func subscribe(topic: String) {
    super.subscribe(topic: topic)
  }

  public override func unsubscribe(topic: String) {
    super.unsubscribe(topic: topic)
  }

  public override func listen() -> AnyPublisher<ChatSignalType, Never> {

    super.listen().sink { [weak self] messageType in
      guard let self else { return }
      if case let .needAuth = messageType {
        TFLogger.dataLogger.notice("401 Error occur")
        guard let token = self.tokenStore.getToken() else {
          TFLogger.dataLogger.error("get token failed!!")
          return
        }
        self.refresh(token: token)
      }
      self.publisher.send(messageType)
    }.store(in: &cancellables)

    return publisher.eraseToAnyPublisher()
  }

  public override func bind() {
    super.bind()
  }
}

// Frame send Connect SEND ...
// 
