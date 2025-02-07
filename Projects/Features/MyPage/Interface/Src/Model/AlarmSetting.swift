//
//  AlarmSetting.swift
//  MyPage
//
//  Created by Kanghos on 6/16/24.
//

import Foundation
import SignUpInterface

import Core
import Domain

public struct AlarmSettingFactory {
  public static func createDefaultAlarmSetting() -> AlarmSetting {
    var defaultAlarmSetting = AlarmSetting.defaultSetting
    let timestamp = Date()
    let markettingAlarm = UserDefaultRepository.shared.fetchModel(for: .marketAgreement, type: MarketingInfoAgreement.self) ?? .init(isAgree: false, timeStamp: timestamp.toDateString())

    defaultAlarmSetting.settings.merge(["marketingAlarm": markettingAlarm.isAgree]) { last, new in
      new
    }
    defaultAlarmSetting.lastUpdated = timestamp
    return defaultAlarmSetting
  }
}

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
