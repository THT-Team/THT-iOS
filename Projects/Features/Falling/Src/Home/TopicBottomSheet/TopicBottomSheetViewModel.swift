//
//  TopicBottomSheetViewModel.swift
//  Falling
//
//  Created by SeungMin on 7/31/25.
//

import SwiftUI

import Domain

@Observable
final class TopicBottomSheetViewModel {
  weak var delegate: TopicActionDelegate?
  var timerViewModel = TimerViewModel()
  
  init(topicExpirationUnixTime: Date? = nil) {
    guard let targetTimeStamp = topicExpirationUnixTime else { return }
    timerViewModel.start(to: targetTimeStamp.timeIntervalSince1970)
  }
}
