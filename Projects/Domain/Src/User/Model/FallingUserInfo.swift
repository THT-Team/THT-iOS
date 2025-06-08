//
//  FallingUserInfo.swift
//  Domain
//
//  Created by Kanghos on 1/6/25.
//

import Foundation

public struct FallingUserInfo {
  public let selectDailyFallingIndex: Int
  public let topicExpirationUnixTime: Date
  public let isLast: Bool
  public let userInfos: [FallingUser]

  public init(selectDailyFallingIndex: Int, topicExpirationUnixTime: Date, isLast: Bool, userInfos: [FallingUser]) {
    self.selectDailyFallingIndex = selectDailyFallingIndex
    self.topicExpirationUnixTime = topicExpirationUnixTime
    self.isLast = isLast
    self.userInfos = userInfos
  }
}
