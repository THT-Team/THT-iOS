//
//  DailyFallingUserRequest.swift
//  Falling
//
//  Created by Kanghos on 2023/10/09.
//

import Foundation

// MARK: - DailyFallingUserRequest
struct DailyFallingUserRequest: Codable {
    let alreadySeenUserUUIDList: [String]
    let userDailyFallingCourserIdx, size: Int

    enum CodingKeys: String, CodingKey {
        case alreadySeenUserUUIDList = "alreadySeenUserUuidList"
        case userDailyFallingCourserIdx, size
    }

  static var empty: Self {
    DailyFallingUserRequest(alreadySeenUserUUIDList: [], userDailyFallingCourserIdx: 1, size: 100)
  }
}
