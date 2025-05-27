//
//  TopicUseCaseInterface.swift
//  Domain
//
//  Created by SeungMin on 4/14/25.
//

import RxSwift

public protocol TopicUseCaseInterface {
  func getCheckIsChooseDailyTopic() -> Single<Bool>
  func getDailyKeyword() -> Single<TopicDailyKeyword>
  func postChoiceTopic(_ fallingIndex: String) -> Single<Void>
  func getTalkKeywords() -> Single<[TopicKeyword]>
}
