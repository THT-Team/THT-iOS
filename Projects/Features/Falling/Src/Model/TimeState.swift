//
//  TimeState.swift
//  Falling
//
//  Created by Kanghos on 6/28/24.
//

import Foundation

import DSKit

enum TimeState {
  case initial(value: Double) // 14~15
  case five(value: Double)    // 12~14
  case four(value: Double)    // 10~12
  case three(value: Double)   // 8~10
  case two(value: Double)     // 6~8
  case one(value: Double)     // 4~6
  case zero(value: Double)    // 2~4
  case over(value: Double)    // 0~2
  case none // Reject(싫어요) or Like(좋아요) or Delete(신고, 차단) user

  init(rawValue: Double) {
    switch rawValue {
    case 14.0..<15.0: self = .initial(value: rawValue)
    case 12.0..<14.0: self = .five(value: rawValue)
    case 10.0..<12.0: self = .four(value: rawValue)
    case 8.0..<10.0: self = .three(value: rawValue)
    case 6.0..<8.0: self = .two(value: rawValue)
    case 4.0..<6.0: self = .one(value: rawValue)
    case 2.0..<4.0: self = .zero(value: rawValue)
    case 0.0..<2.0: self = .over(value: rawValue)
    default: self = .none
    }
  }

  var timerTintColor: DSKitColors {
    switch self {
    case .zero, .five: return DSKitAsset.Color.primary500
    case .four: return DSKitAsset.Color.thtOrange100
    case .three: return DSKitAsset.Color.thtOrange200
    case .two: return DSKitAsset.Color.thtOrange300
    case .one: return DSKitAsset.Color.thtRed
    default: return DSKitAsset.Color.neutral300
    }
  }

  var progressBarColor: DSKitColors {
    switch self {
    case .five: return DSKitAsset.Color.primary500
    case .four: return DSKitAsset.Color.thtOrange100
    case .three: return DSKitAsset.Color.thtOrange200
    case .two: return DSKitAsset.Color.thtOrange300
    case .one: return DSKitAsset.Color.thtRed
    default: return DSKitAsset.Color.neutral600
    }
  }

  var isDotHidden: Bool {
    switch self {
    case .initial, .over, .none: return true
    default: return false
    }
  }

  var trackLayerStrokeColor: DSKitColors {
    switch self {
    case .initial, .over, .none: return DSKitAsset.Color.neutral300
    default: return DSKitAsset.Color.clear
    }
  }

  var getText: String {
    switch self {
    case .five: return "5"
    case .four: return "4"
    case .three: return "3"
    case .two: return "2"
    case .one: return "1"
    case .zero: return "0"
    default: return "-"
    }
  }

  var getProgress: Double {
    switch self {
    case .initial: return 1
    case .five(let value), .four(let value), .three(let value), .two(let value), .one(let value), .zero(let value), .over(let value):
      return round((value / 2 - 2) / 5 * 1000) / 1000
    default: return 0
    }
  }
}
