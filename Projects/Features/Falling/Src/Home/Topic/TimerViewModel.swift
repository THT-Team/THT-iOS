//
//  TimerViewModel.swift
//  Falling
//
//  Created by SeungMin on 6/8/25.
//

import Foundation
import Observation

@Observable
final class TimerViewModel {
  private var timer: Timer?
  var targetTimestamp: TimeInterval = 0
  var remainingTime: TimeInterval = 0
  
  var formattedTime: String {
    DateComponentsFormatter.timerFormatter.string(from: remainingTime) ?? "00:00:00"
  }
  
  var isFinished: Bool {
    return remainingTime == 0
  }
  
  func start(to timestamp: TimeInterval) {
    targetTimestamp = timestamp
    cancel()
    updateRemainingTime()
    
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      guard let self else { return }
      updateRemainingTime()
    }
  }
  
  private func updateRemainingTime() {
    let now = Date().timeIntervalSince1970
    remainingTime = max(0, targetTimestamp - now)
    
    if remainingTime <= 0 {
      cancel()
    }
  }
  
  func cancel() {
    timer?.invalidate()
    timer = nil
  }
  
  deinit {
    cancel()
  }
}
