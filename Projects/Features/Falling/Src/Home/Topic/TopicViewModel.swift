//
//  TopicViewModel.swift
//  Falling
//
//  Created by SeungMin on 5/27/25.
//

import SwiftUI

import Domain

@Observable final class TopicViewModel {
  weak var delegate: TopicActionDelegate?
  var dailyTopicKeyword: TopicDailyKeyword?
  var selectedTopic: DailyKeyword?
  
  var hasChosenDailyTopic: Bool {
    UserDefaultRepository.shared.fetch(for: .hasChosenDailyTopic, type: Bool.self) ?? false
  }
  
  init(delegate: TopicActionDelegate? = nil, dailyTopicKeyword: TopicDailyKeyword? = nil) {
    self.delegate = delegate
    self.dailyTopicKeyword = dailyTopicKeyword
  }
  
  func didTapTopicKeyword(_ topicKeyword: DailyKeyword?) {
    selectedTopic = selectedTopic == topicKeyword ? nil : topicKeyword
  }
  
  func didTapStartButton() {
    guard let selectedTopic = selectedTopic else { return }
    delegate?.didTapStartButton(topic: selectedTopic)
  }
}
