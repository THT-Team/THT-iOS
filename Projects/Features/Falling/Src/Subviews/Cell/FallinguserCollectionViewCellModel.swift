//
//  FallingUserCollectionViewCellModel.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

import Core
import FallingInterface
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

final private class Timer {
  private var disposable: Disposable? = nil
  
  let currentTime = BehaviorRelay<Double>(value: 15.0)
  private var startTime: Double
  
  init(startTime: Double) {
    self.startTime = startTime
  }
  
  func start() {
    guard disposable == nil else { return }
    if startTime < 0 { startTime = 15.0 }
    
    disposable = Observable<Int>.interval(.milliseconds(10),
                                          scheduler: MainScheduler.instance)
    .take(Int(startTime * 100) + 1)
    .map { [weak self] value in
      guard let self = self else { return 0.0 }
      return round((self.startTime * 100 - Double(value))) / 100
    }
    .bind(to: currentTime)
  }
  
  func pause() {
    startTime = currentTime.value
    disposable?.dispose()
    disposable = nil
  }
}

final class FallingUserCollectionViewCellModel: ViewModelType {
  let userDomain: FallingUser
  
  init(userDomain: FallingUser) {
    self.userDomain = userDomain
  }
  
  var disposeBag: DisposeBag = DisposeBag()
  
  struct Input {
    let timerActiveTrigger: Driver<Bool>
    let showUserInfoTrigger: Driver<Bool>
    let rejectButtonTapTrigger: Driver<Void>
    let likeButtonTapTrigger: Driver<Void>
    let reportButtonTapTrigger: Driver<Void>
    let deleteCellTrigger: Driver<Void>
  }
  
  struct Output {
    let user: Driver<FallingUser>
    let timeState: Driver<TimeState>
    let timerActiveAction: Driver<Bool>
    let timeZero: Driver<AnimationAction>
    let rejectButtonAction: Driver<Void>
    let likeButtonAction: Driver<Void>
    let showUserInfoAction: Driver<Bool>
    let reportButtonAction: Driver<Void>
    let deleteCellAction: Driver<Void>
  }
  
  func transform(input: Input) -> Output {
    let timer = Timer(startTime: 15.0)
    let time = timer.currentTime.asDriver(onErrorJustReturn: 0.0)
    let user = Driver.just(userDomain)
    
    let timeState = Driver.merge(
      input.rejectButtonTapTrigger.map { TimeState.none },
      input.likeButtonTapTrigger.map { TimeState.none },
      input.deleteCellTrigger.map { TimeState.none },
      time.map { TimeState(rawValue: $0) }
    )
    
    let timerActiveAction = input.timerActiveTrigger
      .do { value in
        if !value {
          timer.pause()
        } else {
          timer.start()
        }
      }
    
    let timeZero = time.filter { $0 == 0.0 }.flatMapLatest { _ in Driver.just(AnimationAction.scroll) }
    
    let rejectButtonAction = input.rejectButtonTapTrigger
      .do { _ in
        timer.pause()
      }
    
    let likeButtonAction = input.likeButtonTapTrigger
      .do { _ in
        timer.pause()
      }
    
    let showUserInfoAction = input.showUserInfoTrigger
    
    let reportButtonTapTrigger = input.reportButtonTapTrigger
    
    let deleteCellAction = input.deleteCellTrigger
      .do(onNext: {
        timer.pause()
      })
    
    return Output(
      user: user,
      timeState: timeState,
      timerActiveAction: timerActiveAction,
      timeZero: timeZero,
      rejectButtonAction: rejectButtonAction,
      likeButtonAction: likeButtonAction,
      showUserInfoAction: showUserInfoAction,
      reportButtonAction: reportButtonTapTrigger,
      deleteCellAction: deleteCellAction
    )
  }
}
