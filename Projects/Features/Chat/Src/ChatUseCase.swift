//
//  ChatUseCase.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import ChatInterface

import RxSwift

public final class ChatUseCase: ChatUseCaseInterface {
  private let repository: ChatRepositoryInterface
  
  public init(repository: ChatRepositoryInterface) {
    self.repository = repository
  }
  
  public func test() {
    
  }
}

