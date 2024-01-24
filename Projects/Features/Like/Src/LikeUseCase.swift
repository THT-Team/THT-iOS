//
//  LikeUseCase.swift
//  Like
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation

import LikeInterface
import Domain

import RxSwift

public final class LikeUseCase: LikeUseCaseInterface {
  private let repository: LikeRepositoryInterface

  public init(repository: LikeRepositoryInterface) {
    self.repository = repository
  }

  public func fetchList(size: Int, lastTopicIndex: Int?, lastLikeIndex: Int?) -> Observable<LikeListinfo> {
    repository.fetchList(size: size, lastTopicIndex: lastTopicIndex, lastLikeIndex: lastLikeIndex)
  }

  public func user(id: String) -> Observable<UserInfo> {
    repository.user(id: id)
  }
}
