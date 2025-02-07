//
//  TopicKeyword.swift
//  Domain
//
//  Created by Kanghos on 1/6/25.
//

import Foundation

public struct TopicKeyword {
  public let index: Int
  public let keyword: String
  public let keywordImageIndex: Int

  public init(index: Int, keyword: String, keywordImageIndex: Int) {
    self.index = index
    self.keyword = keyword
    self.keywordImageIndex = keywordImageIndex
  }
}
