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
      return round((value / 2 - 1) / 5 * 1000) / 1000
    }
  }
}

final private class Timer {
  private var disposable: Disposable? = nil
  
  let currentTime = BehaviorRelay<Double>(value: 13.0)
  private var startTime: Double
  
  init(startTime: Double) {
    self.startTime = startTime
  }
  
  func start() {
    guard disposable == nil else { return }
    
    disposable = Observable<Int>.interval(.milliseconds(10),
                                          scheduler: MainScheduler.instance)
    .take(Int(startTime * 100) + 1)
    .map { [weak self] value in
      guard let self = self else { return 0.0 }
      return round((self.startTime * 100 - Double(value))) / 100
    }
    .debug()
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
    let timerActiveTrigger: Driver<TimerActiveAction>
    let showUserInfoTrigger: Driver<Bool>
    let rejectButtonTapTrigger: Driver<Void>
    let likeButtonTapTrigger: Driver<Void>
    let reportButtonTapTrigger: Driver<Void>
  }
  
  struct Output {
    let user: Driver<FallingUser>
    let timeState: Driver<TimeState>
    let timeZero: Driver<AnimationAction>
    let timerActiveAction: Driver<TimerActiveAction>
    let rejectButtonAction: Driver<Void>
    let likeButtonAction: Driver<Void>
    let showUserInfoAction: Driver<Bool>
    let reportButtonAction: Driver<Void>
  }
  
  func transform(input: Input) -> Output {
    let timer = Timer(startTime: 13.0)
    let user = Driver.just(self.userDomain)
    
    let timerActiveTrigger = input.timerActiveTrigger
    
    let rejectButtonAction = input.rejectButtonTapTrigger
      .do(onNext: { _ in
        timer.pause()
        timer.currentTime.accept(-1.0) // reject 시에는 0.5초 후에 넘어 가야하는 제약이 있어서, 0초로 설정하지 않았고, reject 버튼 이벤트에 대한 처리는 상위 뷰에서 따로 처리하고 있음.
      })
    
    let likeButtonAction = input.likeButtonTapTrigger
    
    let timeActiveAction = timerActiveTrigger
      .do { action in
        if !action.state {
          timer.pause()
        } else {
          timer.start()
        }
      }
    
    let time = timer.currentTime.asDriver(onErrorJustReturn: 0.0)
    
    let timeState = time.map { TimeState(rawValue: $0) }
    let timeZero = time.filter { $0 == 0.0 }.flatMapLatest { _ in Driver.just(AnimationAction.scroll) }
    let timerActiveAction = timeActiveAction.asDriver(onErrorJustReturn:
        .profileDoubleTap(true))
    
    let showUserInfoAction = input.showUserInfoTrigger
    
    let reportButtonTapTrigger = input.reportButtonTapTrigger
    
    return Output(
      user: user,
      timeState: timeState,
      timeZero: timeZero,
      timerActiveAction: timerActiveAction,
      rejectButtonAction: rejectButtonAction,
      likeButtonAction: likeButtonAction,
      showUserInfoAction: showUserInfoAction,
      reportButtonAction: reportButtonTapTrigger
    )
  }
}
