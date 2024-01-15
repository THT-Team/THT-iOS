//
//  ChatRepository.swift
//  Data
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import ChatInterface
import Networks

import RxSwift
import RxMoya
import Moya

public final class ChatRepository: ProviderProtocol {
  public typealias Target = ChatTarget
  public var provider: MoyaProvider<Target>

  public init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((Target) -> Endpoint)?) {
    self.provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
  }
}

extension ChatRepository: ChatRepositoryInterface {
  public func fetchRooms() -> Single<[ChatRoom]> {
    request(
      type: ChatRoomsRes.self,
      target: .rooms
    )
    .map { $0.map { $0.toDomain() } }
  }
}
