//
//  MainViewModel.swift
//  Falling
//
//  Created by SeungMin on 2023/08/15.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewModel: ViewModelType {
  
  private let navigator: MainNavigator
  var disposeBag: DisposeBag = DisposeBag()
  
  struct Input {
    
  }
  
  struct Output {
    let timerText: Driver<String>
    let progress: Driver<Float>
    let timerColor: Driver<UIColor>
  }
  
  init(navigator: MainNavigator) {
    self.navigator = navigator
  }
  
  func transform(input: Input) -> Output {
    let timer = Observable<Int>.interval(.seconds(1),
                                         scheduler: MainScheduler.instance)
      .take(7)
      .map { 5 - $0 }
      .asDriver(onErrorDriveWith: Driver<Int>.empty())
    
    let timerText = timer.flatMapLatest { timer in
      switch timer {
      case -1:
        return Driver.just("-")
      default:
        return Driver.just(String(timer))
      }
    }
    
    let progress = timer.flatMapLatest { timer in
      return Driver.just(Float(timer) * 0.2)
    }
    
    let timerColor = timer.flatMapLatest { timer in
      switch timer {
      case -1:
        return Driver.just(FallingAsset.Color.neutral300.color)
      case 0, 5:
        return Driver.just(FallingAsset.Color.primary500.color)
      case 1:
        return Driver.just(FallingAsset.Color.thtRed.color)
      case 2, 3, 4:
        return Driver.just(FallingAsset.Color.thtOrange.color)
      default:
        return Driver.just(FallingAsset.Color.neutral300.color)
      }
    }
    
    return Output(
      timerText: timerText,
      progress: progress,
      timerColor: timerColor
    )
  }
}
