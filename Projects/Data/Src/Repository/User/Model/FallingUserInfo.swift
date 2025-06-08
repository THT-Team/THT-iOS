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
    let selectDailyFallingIndex: Int
    let topicExpirationUnixTime: Date
    let isLast: Bool
    let userInfos: [FallingUser.Res]
    
    enum CodingKeys: String, CodingKey {
      case selectDailyFallingIndex = "selectDailyFallingIdx"
      case topicExpirationUnixTime = "topicExpirationUnixTime"
      case isLast
      case userInfos
    }
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)

      self.selectDailyFallingIndex = try container.decode(Int.self, forKey: .selectDailyFallingIndex)
      
      let timestamp = try container.decode(Int.self, forKey: .topicExpirationUnixTime)
      self.topicExpirationUnixTime = Date(timeIntervalSince1970: TimeInterval(timestamp))
      
      self.isLast = try container.decode(Bool.self, forKey: .isLast)
      
      self.userInfos = try container.decode([FallingUser.Res].self, forKey: .userInfos)
    }

    func toDomain() -> FallingUserInfo {
      FallingUserInfo(
        selectDailyFallingIndex: selectDailyFallingIndex,
        topicExpirationUnixTime: topicExpirationUnixTime,
        isLast: isLast,
        userInfos: userInfos.map { $0.toDomain() }
      )
    }
  }

//  init(_ res: Res) {
//    self.init(selectDailyFallingIdx: res.selectDailyFallingIdx,
//                    topicExpirationUnixTime: res.topicExpirationUnixTime,
//                    isLast: res.isLast, userInfos: res.userInfos.map { $0.toDomain() })
//  }
}
