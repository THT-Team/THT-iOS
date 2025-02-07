//
//  LikeUseCaseInterface.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation

import RxSwift
import Core

public protocol LikeUseCaseInterface {
  func fetchList(size: Int, lastTopicIndex: Int?, lastLikeIndex: Int?) -> Single<LikeListinfo>
  func user(id: String) -> Single<UserInfo>
  func reject(index: Int) -> Single<Void>
  func like(id: String, topicID: String) -> Single<LikeMatching>
}

public final class LikeUseCase: LikeUseCaseInterface {

  private let repository: LikeRepositoryInterface

  public init(repository: LikeRepositoryInterface) {
    self.repository = repository
  }

  public func fetchList(size: Int, lastTopicIndex: Int?, lastLikeIndex: Int?) -> Single<LikeListinfo> {
    repository.fetchList(size: size, lastTopicIndex: lastTopicIndex, lastLikeIndex: lastLikeIndex)
  }

  public func user(id: String) -> Single<UserInfo> {
    repository.user(id: id)
  }

  public func reject(index: Int) -> Single<Void> {
    repository.reject(index: index)
  }

  public func like(id: String, topicID: String) -> Single<LikeMatching> {
    repository.like(id: id, topicID: topicID)
  }
}
