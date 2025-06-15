//
//  LikeRepositoryInterface.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation

import RxSwift

public protocol LikeRepositoryInterface {
  func fetchList(size: Int, lastTopicIndex: Int?, lastLikeIndex: Int?) -> Single<LikeListinfo>
  func user(id: String) -> Single<UserInfo>
  func reject(index: Int) -> Single<Void>
  func like(id: String, topicID: String) -> Single<LikeMatching>
  func dontLike(id: String, topicIndex: String) -> Single<Void>
}
