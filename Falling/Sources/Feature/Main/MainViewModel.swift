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
  
  private let navigator: MainNavigator
  var disposeBag: DisposeBag = DisposeBag()
  
  struct Input {
    
  }
  
  struct Output {
    let timerText: Driver<String>
    let progress: Driver<CGFloat>
    let timerColor: Driver<FallingColors>
  }
  
  init(navigator: MainNavigator) {
    self.navigator = navigator
  }
  
  func transform(input: Input) -> Output {
    let timer = Observable<Int>.interval(.milliseconds(10),
                                         scheduler: MainScheduler.instance)
      .take(5 * 100 + 1)
      .map {
        round(Double(5 - Double($0) / 100) * 100) / 100 }
      .asDriver(onErrorDriveWith: Driver<Double>.empty())
    
    let timerText = timer.map { timer in
      switch timer {
      case 0.0.nextUp..<1:
        return "0"
      case 1..<2:
        return "1"
      case 2..<3:
        return "2"
      case 3..<4:
        return "3"
      case 4..<5:
        return "4"
      case 5:
        return "5"
      default:
        return "-"
      }
    }
    
    let progress = timer.map { timer in
      return CGFloat(timer / 5.0)
    }
    
    let timerColor = timer.map { timer in
      switch timer {
      case 0.0.nextUp..<1, 4.0.nextUp...5:
        return FallingAsset.Color.primary500
      case 1..<2:
        return FallingAsset.Color.thtRed
      case 2...4:
        return FallingAsset.Color.thtOrange
      default:
        return FallingAsset.Color.neutral300
      }
    }.asDriver(onErrorJustReturn: FallingAsset.Color.neutral300)
    
    return Output(
      timerText: timerText,
      progress: progress,
      timerColor: timerColor
    )
  }
}
