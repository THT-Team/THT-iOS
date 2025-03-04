//
//  UserReportReq.swift
//  Data
//
//  Created by Kanghos on 1/5/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation

public struct UserReportReq: Codable {
  public let id: String
  public let reason: String

  public init(id: String, reason: String) {
    self.id = id
    self.reason = reason
  }

  enum CodingKeys: String, CodingKey {
    case id = "reportUserUuid"
    case reason
  }
}
