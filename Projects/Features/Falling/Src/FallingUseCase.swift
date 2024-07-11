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

  public func block(userUUID: String) -> Single<Void> {
    .just(())
  }

  public func report(userUUID: String, reason: String) -> Single<Void> {
    .just(())
  }

  public func like(userUUID: String, topicIndex: String) -> RxSwift.Single<Bool> {
    return .just([true, false].randomElement() ?? false)
  }

  public func reject(userUUID: String, topicIndex: String) -> RxSwift.Single<Void> {
    return .just(())
  }

}

