//
//  TopicRepository.swift
//  Domain
//
//  Created by Kanghos on 1/6/25.
//

import Foundation

import RxSwift

public protocol TopicRepositoryInterface {
  func talkKeyword() -> Single<[TopicKeyword]>
  func checkChooseTopic() -> Single<Bool>
  func dailyKeyword() -> Single<[TopicDailyKeyword]>
  func choice(_ fallingIndex: String) -> Single<Void>
}
