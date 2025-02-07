//
//  LikeTopicHelper.swift
//  Like
//
//  Created by Kanghos on 1/5/25.
//

import UIKit
import LikeInterface
import Domain

public struct LikeHelper {
  public static func preprocess(initial: [LikeTopicSection] = [], _ raws: [Like]) -> [LikeTopicSection] {
    var topics: [String] = initial.map { $0.topic }
    var sections: [String: [Like]] = [:]
    initial.forEach { (key, items) in
      sections[key] = items
    }

    raws.forEach { item in
      if sections[item.topic] == nil {
        topics.append(item.topic)
      }
      sections[item.topic, default: []].append(item)
    }

    return topics
      .compactMap { topic -> LikeTopicSection? in
        guard let value = sections[topic] else { return nil }
        return (topic, value)
    }
  }
}

struct OrderedDictionary<Key: Hashable, Value> {
  private var keys: [Key] = []
  private var values: [Key: Value] = [:]

  func values(for key: Key) -> Value? {
    return values[key]
  }

  var orderedKeys: [Key] {
    keys
  }

  mutating func updateValue(_ value: Value, forKey key: Key) {
         if values[key] == nil {
             keys.append(key) // Add key if it's new
         }
         values[key] = value
  }

  func orderedPairs() -> [(Key, Value)] {
    keys.compactMap { key -> (Key, Value)? in
      guard let value = values[key] else { return nil }
      return (key, value)
    }
  }
}
