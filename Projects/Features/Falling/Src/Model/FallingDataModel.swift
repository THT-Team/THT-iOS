//
//  FallingDataModel.swift
//  Falling
//
//  Created by Kanghos on 2/8/25.
//

import Foundation
import Domain

enum FallingDataModel: Hashable, Equatable {
  case fallingUser(FallingUser)
  case notice(NoticeViewCell.Action, UUID)

  func hash(into hasher: inout Hasher) {
    switch self {
    case .fallingUser(let fallingUser):
      hasher.combine(fallingUser)
    case let .notice(_, id):
      hasher.combine(id)
    }
  }

  var user: FallingUser? {
    switch self {
    case .fallingUser(let value):
      return value
    case .notice(let action, let uUID):
      return nil
    }
  }
}
