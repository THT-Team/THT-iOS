//
//  MatchingRes.swift
//  Data
//
//  Created by Kanghos on 1/5/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation
import Domain

extension LikeMatching {
  struct Res: Decodable {
    let isMatching: Bool
    let chatRoomIdx: Int

    func toDomain() -> LikeMatching {
      LikeMatching(isMatching: isMatching, chatRoomIdx: chatRoomIdx)
    }
  }
}
