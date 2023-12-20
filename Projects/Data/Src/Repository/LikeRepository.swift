//
//  LikeRepository.swift
//  Data
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation

import LikeInterface

import RxSwift

public final class LikeRepository: LikeRepositoryInterface {
  private let networkService: LikeService

  public init(networkService: LikeService) {
    self.networkService = networkService
  }

  public func fetchList(size: Int, lastTopicIndex: Int?, lastLikeIndex: Int?) -> Observable<LikeListinfo> {
    networkService.fetchList(size: size, lastTopicIndex: lastTopicIndex, lastLikeIndex: lastLikeIndex)
  }

  public func user(id: String) -> Observable<LikeUserInfo> {
    networkService.user(id: id)
  }

}
