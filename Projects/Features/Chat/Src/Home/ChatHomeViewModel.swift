//
//  ChatHomeViewModel.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import Core
import ChatInterface

final class ChatHomeViewModel: ViewModelType {
  private let chatUseCase: ChatUseCaseInterface
  
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  init(chatUseCase: ChatUseCaseInterface) {
    self.chatUseCase = chatUseCase
  }
  
  func transform(input: Input) -> Output {
    return Output()
  }
}
