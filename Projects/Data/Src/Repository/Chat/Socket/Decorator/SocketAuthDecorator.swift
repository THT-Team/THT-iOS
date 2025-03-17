//
//  SocketAuthDecorator.swift
//  Domain
//
//  Created by Kanghos on 2/8/25.
//

import Foundation
import Combine
import Core
import Domain

public final class SocketAuthDecorator: BaseSocketDecorator {
  private var queue = DispatchQueue(label: "com.example.SocketAuthDecorator")

  private var _batchPayload: [Payload] = []

  private var batchPayload: [Payload] {
    get { queue.sync { self._batchPayload } }
    set { queue.async { self._batchPayload = newValue } }
  }

  var refreshCount = 2

  private let publisher = PassthroughSubject<ChatSignalType, Never>()
  private var cancellables: Set<AnyCancellable> = []

  private let tokenService: TokenServiceType
  private let wrappee: SocketInterface

  public init(_ wrappee: SocketInterface, _ tokenService: TokenServiceType) {
    self.tokenService = tokenService
    self.wrappee = wrappee
    super.init(wrappee)
  }

  public override func replace(_ config: ChatConfiguration, header: [String : String]) {
    super.replace(config, header: makeAuthHeader(header))
  }

  public override func connect() {
    super.connect()
  }

  public override func disconnect() {
    super.disconnect()
    cancellables.forEach { $0.cancel() }
  }

  public override func send(destination: String, sender: ChatRoomInfo.Participant, message: String, receiptID: String, header: [String : String]) {
    super.send(destination: destination, sender: sender, message: message, receiptID: receiptID, header: makeAuthHeader(header))
  }

  public override func subscribe(topic: String, header: [String : String]) {
    super.subscribe(topic: topic, header: makeAuthHeader(header))
  }

  public override func unsubscribe(topic: String, header: [String : String]) {
    super.unsubscribe(topic: topic, header: makeAuthHeader(header))
  }

  public override func listen() -> AnyPublisher<ChatSignalType, Never> {
    return publisher.eraseToAnyPublisher()
  }

  public override func bind() {
    super.bind()

    super.listen()
      .sink { [weak self] messageType in
      guard let self else { return }
      if case .needAuth = messageType {
        TFLogger.dataLogger.notice("401 Error occur")
        connect()
        return
      }
      self.publisher.send(messageType)
    }
      .store(in: &cancellables)
  }
}

extension SocketAuthDecorator {
  func resend() {
    Task {
      do {
        let token = try await tokenService.refreshToken()
        sendPendingFrames(token: token)
      } catch {
        NotificationCenter.default.post(name: .needAuthLogout, object: nil)
      }
    }
  }

  func sendPendingFrames(token: Token) {
    batchPayload.forEach { payload in
      self.send(
        destination: payload.destination,
        sender: payload.sender,
        message: payload.message,
        receiptID: payload.receiptID,
        header: makeAuthHeader(payload.headers, token: token)
      )
    }
    batchPayload.removeAll()
  }

  func appendFrame(_ payload: Payload) {
    batchPayload.append(payload)
  }

  func removeAllAppendedFrames() {
    batchPayload.removeAll()
  }
}

extension SocketAuthDecorator {

  struct Payload {
    let destination: String
    let sender: ChatRoomInfo.Participant
    let message: String
    let receiptID: String
    let headers: [String: String]
  }

  func makeAuthHeader(_ base: [String: String]) -> [String: String] {
    guard let token = tokenService.getToken() else {
      return base
    }

    return makeAuthHeader(base, token: token)
  }

  private func makeAuthHeader(_ base: [String: String], token: Token) -> [String: String] {
    return base.merging(authHeader(token.accessToken)) { _, new in new }
  }

  private func authHeader(_ token: String) -> [String: String] {
    [
      "Authorization": "\(token)"
    ]
  }
}

extension SocketAuthDecorator {
  public static func createAuthSocket(
    tokenService: TokenServiceType
  ) -> SocketInterface {
    SocketAuthDecorator(
      SocketComponent(config: ChatConfiguration(initialToken: tokenService.getToken()?.accessToken)),
      tokenService)
  }
}
