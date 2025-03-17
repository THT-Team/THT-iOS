//
//  FallingRepository.swift
//  Data
//
//  Created by SeungMin on 1/11/24.
//

import Foundation
import Networks

import RxSwift
import Moya

import Domain

public typealias FallingRepository = BaseRepository<FallingTarget>

extension FallingRepository: FallingRepositoryInterface {
  public func user(alreadySeenUserUUIDList: [String], userDailyFallingCourserIdx: Int, size: Int) -> Single<FallingUserInfo> {
    request(
      type: FallingUserInfo.Res.self,
      target: .users(
        FallingUserReq(
        alreadySeenUserUUIDList: alreadySeenUserUUIDList,
        userDailyFallingCourserIdx: userDailyFallingCourserIdx,
        size: size
        )
      )
    )
    .map { $0.toDomain() }
  }
}
