//
//  FallingUserInfo.swift
//  Domain
//
//  Created by Kanghos on 1/6/25.
//

import Foundation

public struct FallingUserInfo {
  public let selectDailyFallingIdx: Int
  public let topicExpirationUnixTime: Int
  public let isLast: Bool
  public let userInfos: [FallingUser]

  public init(selectDailyFallingIdx: Int, topicExpirationUnixTime: Int, isLast: Bool, userInfos: [FallingUser]) {
    self.selectDailyFallingIdx = selectDailyFallingIdx
    self.topicExpirationUnixTime = topicExpirationUnixTime
    self.isLast = isLast
    self.userInfos = userInfos
  }
}
