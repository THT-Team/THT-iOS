//
//  TopicViewModel.swift
//  Falling
//
//  Created by SeungMin on 5/27/25.
//

import Observation

import Domain

@Observable
final class TopicViewModel {
  weak var delegate: TopicActionDelegate?
  var timerViewModel = TimerViewModel()
  
  var dailyTopicKeyword: TopicDailyKeyword?
  var selectedTopic: DailyKeyword?
  
  var hasChosenDailyTopic: Bool {
    UserDefaultRepository.shared.fetch(for: .hasChosenDailyTopic, type: Bool.self) ?? false
  }
  
  init(delegate: TopicActionDelegate? = nil, dailyTopicKeyword: TopicDailyKeyword? = nil) {
    self.delegate = delegate
    self.dailyTopicKeyword = dailyTopicKeyword
    
    guard let targetTimeStamp = dailyTopicKeyword?.expirationUnixTime else { return }
    timerViewModel.start(to: targetTimeStamp.timeIntervalSince1970)
  }
  
  func didTapTopicKeyword(_ topicKeyword: DailyKeyword?) {
    selectedTopic = selectedTopic == topicKeyword ? nil : topicKeyword
  }
  
  func didTapStartButton() {
    guard let selectedTopic = selectedTopic else { return }
    delegate?.didTapStartButton(topic: selectedTopic)
  }
  
  func didFinishDailyTopic() {
    delegate?.didFinishDailyTopic()
  }
}
