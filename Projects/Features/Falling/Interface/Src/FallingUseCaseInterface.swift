//
//  FallingUseCaseInterface.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Foundation
import Domain

import RxSwift

public protocol FallingUseCaseInterface {
  func user(alreadySeenUserUUIDList: [String], userDailyFallingCourserIdx: Int, size: Int) -> Single<FallingUserInfo>
  func block(userUUID: String) -> Single<Void>
  func report(userUUID: String, reason: String) -> Single<Void>
  func like(userUUID: String, topicIndex: String) -> Single<Bool>
  func reject(userUUID: String, topicIndex: String) -> Single<Void>
}

