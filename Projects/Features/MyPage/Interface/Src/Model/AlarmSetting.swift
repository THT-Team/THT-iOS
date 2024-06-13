//
//  AlarmSetting.swift
//  MyPage
//
//  Created by Kanghos on 6/16/24.
//

import Foundation

public struct AlarmSetting: Codable {
  public var settings: [String: Bool]
  public var lastUpdated: Date?

  public init(settings: [String : Bool], lastUpdated: Date?) {
    self.settings = settings
    self.lastUpdated = lastUpdated
  }
}

extension AlarmSetting {
  public static var defaultSetting: AlarmSetting {
    AlarmSetting(
      settings: [
        "marketingAlarm": true,
        "newMatchSuccessAlarm": true,
        "likeMeAlarm": true,
        "newConversationAlarm": true,
        "talkAlarm": true,
        "countdownAlarm": true,
        "realTimeMatchAlarm": true,
      ],
      lastUpdated: nil
    )
  }
}
