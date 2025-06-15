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
  func dontLike(id: String, topicIndex: String) -> Single<Void>
  func save(id: Int)
}

public final class LikeUseCase: LikeUseCaseInterface {

  private let repository: LikeRepositoryInterface
  private let likeStore: LikeLocalStore

  public init(repository: LikeRepositoryInterface) {
    self.repository = repository
    self.likeStore = LikeLocalStore()
  }

  public func fetchList(size: Int, lastTopicIndex: Int?, lastLikeIndex: Int?) -> Single<LikeListinfo> {
    repository.fetchList(size: size, lastTopicIndex: lastTopicIndex, lastLikeIndex: lastLikeIndex)
      .map { [weak self] info in
        guard let indices = self?.likeStore.retrieveIndices() else { return info }
        let processed = info.likeList.map { like in
          var like = like
          like.isNew = indices.contains(like.likeIdx)
          return like
        }

        return LikeListinfo(likeList: processed, size: info.size, lastFallingTopicIdx: info.lastFallingTopicIdx, lastLikeIdx: info.lastLikeIdx)
      }
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
  
  public func dontLike(id: String, topicIndex: String) -> Single<Void> {
    repository.dontLike(id: id, topicIndex: topicIndex)
  }

  public func save(id: Int) {
    likeStore.save(id)
  }
}

class LikeLocalStore {
  init() {
    UserDefaultRepository.shared.remove(key: .likeIndices)
  }
  func retrieveIndices() -> Set<Int> {
    UserDefaultRepository.shared.fetchModel(for: .likeIndices, type: Set<Int>.self) ?? []
  }

  func save(_ index: Int) {
    UserDefaultRepository.shared.saveModel(retrieveIndices().union([index]), key: .likeIndices)
  }
}
