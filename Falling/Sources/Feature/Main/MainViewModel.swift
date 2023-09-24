//
//  MainViewModel.swift
//  Falling
//
//  Created by SeungMin on 2023/08/15.
//

import RxSwift
import RxCocoa
import Foundation

final class MainViewModel: ViewModelType {
  
  enum TimeState {
    case initial // 7~8
    case high  // 6~7
    case middle // 3~6
    case low // 2~3
    case zero // 1~2
    case over // 0~1
    
    init(rawValue: Double) {
      switch rawValue {
      case 7.0..<8.0:
        self = .initial
      case 6.0..<7.0:
        self = .high
      case 3.0..<6.0:
        self = .middle
      case 2.0..<3.0:
        self = .low
      case 1.0..<2.0:
        self = .zero
      default:
        self = .over
      }
    }
    
    var color: FallingColors {
      switch self {
      case .zero, .high:
        return FallingAsset.Color.primary500
      case .middle:
        return FallingAsset.Color.thtOrange
      case .low:
        return FallingAsset.Color.thtRed
      default:
        return FallingAsset.Color.neutral300
      }
    }
    
    var isDotHidden: Bool {
      switch self {
      case .initial, .over:
        return true
      default:
        return false
      }
    }
    
    var fillColor: FallingColors {
      switch self {
      case .over:
        return FallingAsset.Color.neutral300
      default:
        return FallingAsset.Color.clear
      }
    }
    
    func getText(value: Double) -> String {
      switch self {
      case .initial, .over:
        return String("-")
      default:
        return String(Int(value) - 1)
      }
    }
    
    func getProgress(value: Double) -> Float {
      switch self {
      case .initial:
        return 1
      default:
        return Float((value - 2) / 5)
      }
    }
  }
  
  private let navigator: MainNavigator
  var disposeBag: DisposeBag = DisposeBag()
  
  struct Input {
    
  }
  
  struct Output {
    let timeText: Driver<String>
    let progress: Driver<Float>
    let timeColor: Driver<FallingColors>
    let dotPosition: Driver<CGPoint>
    let isDotHidden: Driver<Bool>
    let trackFillColor: Driver<FallingColors>
  }
  
  init(navigator: MainNavigator) {
    self.navigator = navigator
  }
  
  func transform(input: Input) -> Output {
    let time = Observable<Int>.interval(.milliseconds(10),
                                        scheduler: MainScheduler.instance)
      .take(8 * 100 + 1)
      .map { round((8 - Double($0) / 100) * 100) / 100 }
      .asDriver(onErrorDriveWith: Driver<Double>.empty())
    
    let timeText = time.map { time in
      let timerState = TimeState(rawValue: time)
      return timerState.getText(value: time)
    }
    
    let progress = time.map { time in
      let timerState = TimeState(rawValue: time)
      return timerState.getProgress(value: time)
    }
    
    let timeColor = time.map { time in
      let timerState = TimeState(rawValue: time)
      return timerState.color
    }.asDriver(onErrorJustReturn: FallingAsset.Color.neutral300)
    
    let dotPosition = progress.map { progress in
      var progress = round(progress * 100) / 100
      if progress > 0.95 || progress < -0.05 { progress = 0.95 }
      let radius = CGFloat(22 / 2 - 2 / 2)
      let angle = 2 * CGFloat.pi * CGFloat(progress) - CGFloat.pi / 2
      let dotX = radius * cos(angle + 0.3)
      let dotY = radius * sin(angle + 0.3)
      return CGPoint(x: dotX, y: dotY)
    }
    
    let isDotHidden = time.map { time in
      let timeState = TimeState(rawValue: time)
      return timeState.isDotHidden
    }.asDriver(onErrorJustReturn: true)
    
    let trackFillColor = time.map { time in
      let timerState = TimeState(rawValue: time)
      return timerState.fillColor
    }.asDriver(onErrorJustReturn: FallingAsset.Color.clear)
    
    return Output(
      timeText: timeText,
      progress: progress,
      timeColor: timeColor,
      dotPosition: dotPosition,
      isDotHidden: isDotHidden,
      trackFillColor: trackFillColor
    )
  }
}
