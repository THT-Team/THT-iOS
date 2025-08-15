//
//  TFTimer.swift
//  Falling
//
//  Created by Kanghos on 6/28/24.
//

import Foundation

import RxSwift
import RxCocoa

final class TFTimer {
  private var disposable: Disposable? = nil
  
  let currentTime = BehaviorRelay<Double>(value: 15.0)
  
  private var startTime: Double
  private let duration: Double
  
  init(duration: Double) {
    self.duration = duration
    self.startTime = duration
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
    cancel()
  }
  
  func reset() {
    startTime = duration
    cancel()
  }
  
  func cancel() {
    disposable?.dispose()
    disposable = nil
  }
}

extension TFTimer {
  var seconds: Observable<Double> {
    currentTime.share()
  }
  var timeOut: Observable<Void> {
    seconds
      .filter { $0 == .zero }
      .mapToVoid()
  }
}
