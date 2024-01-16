//
//  MyPageHomeViewModel.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import Core
import MyPageInterface

final class MyPageHomeViewModel: ViewModelType {
  private let myPageUseCase: MyPageUseCaseInterface
  
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  init(myPageUseCase: MyPageUseCaseInterface) {
    self.myPageUseCase = myPageUseCase
  }
  
  func transform(input: Input) -> Output {
    return Output()
  }
}
