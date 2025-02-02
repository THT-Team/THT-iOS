//
//  LikeUseCaseInterface.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation
import Domain

import RxSwift

public protocol LikeUseCaseInterface {
  func fetchList(size: Int, lastTopicIndex: Int?, lastLikeIndex: Int?) -> Single<LikeListinfo>
  func user(id: String) -> Single<UserInfo>
  func reject(index: Int) -> Single<Void>
}
