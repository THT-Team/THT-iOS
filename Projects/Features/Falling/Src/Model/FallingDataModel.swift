//
//  FallingDataModel.swift
//  Falling
//
//  Created by Kanghos on 2/8/25.
//

import Foundation
import Domain

import UIKit

enum FallingDataModel: Hashable, Equatable {
  case dailyKeyword(TopicDailyKeyword)
  case fallingUser(FallingUser)
  case notice(NoticeViewCell.Action, UUID)
  case dummyUser(UIImage, UUID)

  func hash(into hasher: inout Hasher) {
    switch self {
    case .dailyKeyword(let dailyKeyword):
      hasher.combine(dailyKeyword)
    case .fallingUser(let fallingUser):
      hasher.combine(fallingUser)
    case let .notice(_, id):
      hasher.combine(id)
    case let .dummyUser(_, id):
      hasher.combine(id)
    }
  }

  var user: FallingUser? {
    switch self {
    case .fallingUser(let value):
      return value
    default:
      return nil
    }
  }
  
  var dailyKeyword: TopicDailyKeyword? {
    switch self {
    case .dailyKeyword(let value):
      return value
    default:
      return nil
    }
  }
}
