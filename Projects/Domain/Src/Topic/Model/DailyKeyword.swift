//
//  DailyKeyword.swift
//  Domain
//
//  Created by Kanghos on 1/6/25.
//

import Foundation

public struct DailyKeyword {
  public let index: Int
  public let keyword: String
  public let keywordIndex: Int
  public let keywordImageURL: String
  public let talkIssue: String

  public init(index: Int, keyword: String, keywordIndex: Int, keywordImageURL: String, talkIssue: String) {
    self.index = index
    self.keyword = keyword
    self.keywordIndex = keywordIndex
    self.keywordImageURL = keywordImageURL
    self.talkIssue = talkIssue
  }
}
