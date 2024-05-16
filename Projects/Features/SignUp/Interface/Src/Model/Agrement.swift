//
//  Agrement.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import Foundation

public struct Agreement: Codable {
  public let keys: [String: Bool]

  public init(keys: [String : Bool]) {
    self.keys = keys
  }
}

extension Agreement {
  func toDictionary() -> [String: Any] {
    do {
      let data = try JSONEncoder().encode(keys)
      let dic = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) as? [String: Any]
      return dic ?? [:]
    } catch {
      return [:]
    }
  }
}
