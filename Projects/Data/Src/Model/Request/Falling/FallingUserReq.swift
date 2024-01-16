//
//  FallingUserReq.swift
//  Data
//
//  Created by SeungMin on 1/11/24.
//

import Foundation

// MARK: - FallingUserReq
public struct FallingUserReq: Codable {
  public let alreadySeenUserUUIDList: [String]
  public let userDailyFallingCourserIdx, size: Int
  
  public enum CodingKeys: String, CodingKey {
    case alreadySeenUserUUIDList = "alreadySeenUserUuidList"
    case userDailyFallingCourserIdx, size
  }
  
  public init(alreadySeenUserUUIDList: [String], userDailyFallingCourserIdx: Int, size: Int) {
    self.alreadySeenUserUUIDList = alreadySeenUserUUIDList
    self.userDailyFallingCourserIdx = userDailyFallingCourserIdx
    self.size = size
  }
  
  public static var empty: Self {
    FallingUserReq(alreadySeenUserUUIDList: [], userDailyFallingCourserIdx: 1, size: 100)
  }
}
