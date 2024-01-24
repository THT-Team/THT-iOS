//
//  FallingUseCase.swift
//  Falling
//
//  Created by SeungMin on 1/12/24.
//

import Foundation

import FallingInterface

import RxSwift

public final class FallingUseCase: FallingUseCaseInterface {
  private let repository: FallingRepositoryInterface
  
  public init(repository: FallingRepositoryInterface) {
    self.repository = repository
  }
  
  public func user(alreadySeenUserUUIDList: [String], userDailyFallingCourserIdx: Int, size: Int) -> Single<FallingUserInfo> {
    self.repository.user(
      alreadySeenUserUUIDList: alreadySeenUserUUIDList,
      userDailyFallingCourserIdx: userDailyFallingCourserIdx,
      size: size
    )
  }
}

