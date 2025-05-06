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
    let chatRoomIdx: Int?

    func toDomain() -> LikeMatching {
      LikeMatching(isMatching: isMatching, chatRoomIdx: chatRoomIdx)
    }

    enum CodingKeys: CodingKey {
      case isMatching
      case chatRoomIdx
    }

    init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<LikeMatching.Res.CodingKeys> = try decoder.container(keyedBy: LikeMatching.Res.CodingKeys.self)
      self.isMatching = try container.decode(Bool.self, forKey: LikeMatching.Res.CodingKeys.isMatching)
      do {
        self.chatRoomIdx = try container.decode(Int.self, forKey: LikeMatching.Res.CodingKeys.chatRoomIdx)
      } catch {
        self.chatRoomIdx = nil
      }
    }
  }
}
