//
//  MyPageUseCase.swift
//  MyPageInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import MyPageInterface

import RxSwift

public final class MyPageUseCase: MyPageUseCaseInterface {
  private let repository: MyPageRepositoryInterface
  
  public init(repository: MyPageRepositoryInterface) {
    self.repository = repository
  }
  
  public func test() {
    
  }
}

