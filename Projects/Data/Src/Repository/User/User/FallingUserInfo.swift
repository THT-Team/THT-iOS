//
//  FallingUserInfo.swift
//  Data
//
//  Created by Kanghos on 1/6/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation
import Domain

extension FallingUserInfo {
  struct Res: Decodable {
    let selectDailyFallingIdx: Int
    let topicExpirationUnixTime: Int
    let isLast: Bool
    let userInfos: [FallingUser.Res]

    func toDomain() -> FallingUserInfo {
      FallingUserInfo(
        selectDailyFallingIdx: selectDailyFallingIdx,
        topicExpirationUnixTime: topicExpirationUnixTime,
        isLast: isLast,
        userInfos: userInfos.map { $0.toDomain() }
      )
    }
  }
}
