//
//  TopicRepository.swift
//  Domain
//
//  Created by Kanghos on 1/6/25.
//

import Foundation

import RxSwift

public protocol TopicRepositoryInterface {
  func getCheckIsChooseDailyTopic() -> Single<Bool>
  func getDailyKeyword() -> Single<TopicDailyKeyword>
  func postChoiceTopic(_ fallingIndex: String) -> Single<Void>
  func getTalkKeywords() -> Single<[TopicKeyword]>
}
