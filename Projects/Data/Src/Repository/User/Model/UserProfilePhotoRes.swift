//
//  UserInfoRes.swift
//  Data
//
//  Created by Kanghos on 2024/01/16.
//

import Foundation

import Domain

extension UserProfilePhoto {
  struct Res: Decodable {
    public let url: String
    public let priority: Int

    func toDomain() -> UserProfilePhoto {
      UserProfilePhoto(url: url, priority: priority)
    }
  }
  struct Req: Encodable {
    let url: String
    let priority: Int
  }
}
