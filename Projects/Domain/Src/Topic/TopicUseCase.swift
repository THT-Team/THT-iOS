//
//  TopicUseCase.swift
//  Domain
//
//  Created by SeungMin on 4/14/25.
//

import RxSwift

public final class TopicUseCase: TopicUseCaseInterface {
  
  private let repository: TopicRepositoryInterface

  public init(repository: TopicRepositoryInterface) {
    self.repository = repository
  }
  
  public func getCheckIsChooseDailyTopic() -> Single<Bool> {
    self.repository.getCheckIsChooseDailyTopic()
  }
  
  public func getDailyKeyword() -> Single<TopicDailyKeyword> {
    self.repository.getDailyKeyword()
  }

  public func postChoiceTopic(_ fallingIndex: String) -> Single<Void> {
    self.repository.postChoiceTopic(fallingIndex)
  }
  
  public func getTalkKeywords() -> Single<[TopicKeyword]> {
    self.repository.getTalkKeywords()
  }
}
