//
//  TopicKeyword.swift
//  Data
//
//  Created by Kanghos on 1/6/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation
import Domain

extension TopicKeyword {
  struct Res: Decodable {
    let index: Int
    let keyword: String
    let keywordImageIndex: Int

    enum CodingKeys: String, CodingKey {
      case index = "idx"
      case keyword
      case keywordImageIndex = "keywordImgIdx"
    }

    func toDomain() -> TopicKeyword {
      TopicKeyword(index: index, keyword: keyword, keywordImageIndex: keywordImageIndex)
    }
  }
}
