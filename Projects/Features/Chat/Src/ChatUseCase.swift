//
//  ChatUseCase.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import ChatInterface
import RxSwift

public final class ChatUseCase {
  private let repository: ChatRepositoryInterface

  public init(repository: ChatRepositoryInterface) {
    self.repository = repository
  }
}

extension ChatUseCase: ChatUseCaseInterface {
  public func fetchRooms() -> RxSwift.Single<[ChatRoom]> {
    repository.fetchRooms()
  }
}
