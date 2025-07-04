//
//  FallingUseCaseInterface.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

import RxSwift

public protocol FallingUseCaseInterface {
  func user(alreadySeenUserUUIDList: [String], userDailyFallingCourserIdx: Int, size: Int) -> Single<FallingUserInfo>
}
