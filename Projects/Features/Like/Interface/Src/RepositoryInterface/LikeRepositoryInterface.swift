//
//  LikeRepositoryInterface.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation
import Domain

import RxSwift

public protocol LikeRepositoryInterface {
  func fetchList(size: Int, lastTopicIndex: Int?, lastLikeIndex: Int?) -> Observable<LikeListinfo>
  func user(id: String) -> Observable<UserInfo>
}
