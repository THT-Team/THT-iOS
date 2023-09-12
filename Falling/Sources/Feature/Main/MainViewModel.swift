//
//  MainViewModel.swift
//  Falling
//
//  Created by SeungMin on 2023/08/15.
//

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
    let timerColor: Driver<FallingColors>
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
    
    let timerText = timer.map { timer in
      switch timer {
      case -1:
        return "-"
      default:
        return String(timer)
      }
    }
    
    let progress = timer.map { timer in
      return Float(timer) * 0.2
    }
    
    let timerColor = timer.map { timer in
      switch timer {
      case -1:
        return FallingAsset.Color.neutral300
      case 0, 5:
        return FallingAsset.Color.primary500
      case 1:
        return FallingAsset.Color.thtRed
      case 2, 3, 4:
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
