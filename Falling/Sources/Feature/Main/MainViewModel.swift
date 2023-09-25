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
    case initial(value: Double) // 7~8
    case high(value: Double)  // 6~7
    case middle(value: Double) // 3~6
    case low(value: Double) // 2~3
    case zero(value: Double) // 1~2
    case over(value: Double) // 0~1
    
    init(rawValue: Double) {
      switch rawValue {
      case 7.0..<8.0:
        self = .initial(value: rawValue)
      case 6.0..<7.0:
        self = .high(value: rawValue)
      case 3.0..<6.0:
        self = .middle(value: rawValue)
      case 2.0..<3.0:
        self = .low(value: rawValue)
      case 1.0..<2.0:
        self = .zero(value: rawValue)
      default:
        self = .over(value: rawValue)
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
    
    var getText: String {
      switch self {
      case .initial, .over:
        return String("-")
      case .high(let value), .low(let value), .middle(let value), .zero(let value):
        return String(Int(value) - 1)
      }
    }
    
    var getProgress: Double {
      switch self {
      case .initial:
        return 1
      case .high(let value), .low(let value), .middle(let value), .zero(let value), .over(let value):
        return ((value - 2) / 5)
      }
    }
  }
  
  private let navigator: MainNavigator
  var disposeBag: DisposeBag = DisposeBag()
  
  struct Input {
    
  }
  
  struct Output {
    let state: Driver<TimeState>
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

    let state = time.map { TimeState(rawValue: $0) }
      .debug()
    
    return Output(
      state: state
    )
  }
}
