//
//  ChatRepository.swift
//  Data
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import ChatInterface
import Networks

import RxSwift
import Moya

public final class ChatRepository: ProviderProtocol {
  public typealias Target = ChatTarget
  public var provider: MoyaProvider<Target>
  public init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((Target) -> Moya.Endpoint)?) {
    self.provider = ChatRepository.consProvider(isStub, sampleStatusCode, customEndpointClosure)
  }
}


extension ChatRepository: ChatRepositoryInterface {
  public func test() {
    
  }
}
