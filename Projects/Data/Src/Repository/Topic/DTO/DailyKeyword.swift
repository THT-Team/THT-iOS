//
//  DailyKeyword.swift
//  Data
//
//  Created by Kanghos on 1/6/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation
import Domain

extension DailyKeyword {
  struct Res: Decodable {
    let index: Int
    let keyword: String
    let keywordIndex: Int
    let keywordImageURL: String
    let talkIssue: String

    enum CodingKeys: String, CodingKey {
      case index = "idx"
      case keyword
      case keywordIndex = "keywordIdx"
      case keywordImageURL = "keywordImgUrl"
      case talkIssue
    }

    func toDomain() -> DailyKeyword {
      DailyKeyword(index: index, keyword: keyword, keywordIndex: keywordIndex, keywordImageURL: keywordImageURL, talkIssue: talkIssue)
    }
  }
}
