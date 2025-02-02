//
//  TopicTarget.swift
//  Data
//
//  Created by Kanghos on 1/6/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation

import Networks

import Moya

public enum TopicTarget {
  case talkKeyword
  case checkDailyTopic
  case dailyKeyword
  case choice(String)
}

extension TopicTarget: BaseTargetType {
  public var path: String {
    switch self {
    case .talkKeyword:
      return "all/talk-keyword"
    case .checkDailyTopic:
      return "check/is-choose-daily-topic"
    case .dailyKeyword:
      return "falling/daily-keyword"
    case let .choice(index):
      return "falling/choice/daily-keyword/\(index)"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .talkKeyword:
      return .get
    case .checkDailyTopic:
      return .get
    case .dailyKeyword:
      return .get
    case .choice:
      return .post
    }
  }

  public var task: Task {
    switch self {
    case .talkKeyword:
      return .requestPlain
    case .checkDailyTopic:
      return .requestPlain
    case .dailyKeyword:
      return .requestPlain
    case .choice(let string):
      return .requestPlain
    }
  }
}
