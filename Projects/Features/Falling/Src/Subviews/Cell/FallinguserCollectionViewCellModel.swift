//
//  FallinguserCollectionViewCellModel.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

import Core
import FallingInterface
import DSKit

enum TimeState {
  case initial(value: Double) // 12~13
  case five(value: Double)    // 10~12
  case four(value: Double)    // 8~10
  case three(value: Double)   // 6~8
  case two(value: Double)     // 4~6
  case one(value: Double)     // 2~4
  case zero(value: Double)    // 1~2
  case over(value: Double)    // 0~1
  
  init(rawValue: Double) {
    switch rawValue {
    case 12.0..<13.0: self = .initial(value: rawValue)
    case 10.0..<12.0: self = .five(value: rawValue)
    case 8.0..<10.0: self = .four(value: rawValue)
    case 6.0..<8.0: self = .three(value: rawValue)
    case 4.0..<6.0: self = .two(value: rawValue)
    case 2.0..<4.0: self = .one(value: rawValue)
    case 1.0..<2.0: self = .zero(value: rawValue)
    default: self = .over(value: rawValue)
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
    case .initial, .over: return true
    default: return false
    }
  }
  
  var fillColor: DSKitColors {
    switch self {
    case .over: return DSKitAsset.Color.neutral300
    default: return DSKitAsset.Color.clear
    }
  }
  
  var getText: String {
    switch self {
    case .initial, .over: return "-"
    case .five: return "5"
    case .four: return "4"
    case .three: return "3"
    case .two: return "2"
    case .one: return "1"
    case .zero: return "0"
    }
  }
  
  var getProgress: Double {
    switch self {
    case .initial: return 1
    case .five(let value), .four(let value), .three(let value), .two(let value), .one(let value), .zero(let value), .over(let value):
      return (value / 2 - 1) / 5
    }
  }
  
  // .pi / 360 == 1도
  var rotateAngle: CGFloat {
    switch self {
    case .four:
      // 8 10 => 초당 0.5도
      return .pi / 360 / 200
    case .three:
      // 6 8 => 초당 1도
      return -.pi / 360 / 100
    case .two(let value):
      // 4 6 => 초당 2도
      let time = round((3-value/2) * 100) / 100
      if time <= 0.5 { return .pi / 360 / 50 }
      else { return -.pi / 360 / 50 }
    case .one(let value):
      // 2 4 => 초당 4도
      let time = round((2-value/2) * 100) / 100
      if time <= 0.25 { return .pi / 360 / 50 }
      else if 0.25 < time && time <= 0.5 { return -.pi / 360 / 50 }
      else if 0.5 < time && time <= 0.75 { return .pi / 360 / 50 }
      else { return -.pi / 360 / 50 }
    case .zero:
      // 1 2 => 초당 1도
      return .pi / 360 / 100
    default:
      return 0
    }
  }
}

final class FallinguserCollectionViewCellModel: ViewModelType {
  let userDomain: FallingUser
  
  init(userDomain: FallingUser) {
    self.userDomain = userDomain
  }
  
  var disposeBag: DisposeBag = DisposeBag()
  
  struct Input {
    let timerActiveTrigger: Driver<Bool>
  }
  
  struct Output {
    let user: Driver<FallingUser>
    let timeState: Driver<TimeState>
    let timeStart: Driver<Void>
    let timeZero: Driver<Void>
    let isTimerActive: Driver<Bool>
  }
  
  func transform(input: Input) -> Output {
    var currentTime: Double = 13.0
    var startTime: Double = 13.0
    let user = Driver.just(self.userDomain)
    
    let timerActiveTrigger = input.timerActiveTrigger
      .asObservable()
    
    let timer = timerActiveTrigger
      .flatMapLatest { value in
        if !value {
          startTime = currentTime // 타이머가 멈췄을 때 현재 시간으로 갱신
          return Driver.just(currentTime)
        } else {
          return Observable<Int>.interval(.milliseconds(10),
                                          scheduler: MainScheduler.instance)
          .take(Int(startTime * 100) + 1) // 시간의 총 개수
          .map { value in
            currentTime = round((startTime * 100 - Double(value))) / 100 // 현재 시간 갱신
            return currentTime
          }
          .debug()
          .asDriver(onErrorJustReturn: currentTime)
        }
      }.asDriver(onErrorJustReturn: currentTime)
    
    let timeState = timer.map { TimeState(rawValue: $0) }
    let timeStart = timer.filter { $0 == 13.0 }.map { _ in }
    let timeZero = timer.filter { $0 == 0.0 }.map { _ in }
    let isTimerActive = timerActiveTrigger.asDriver(onErrorJustReturn: true)

    return Output(
      user: user,
      timeState: timeState,
      timeStart: timeStart,
      timeZero: timeZero,
      isTimerActive: isTimerActive
    )
  }
}
