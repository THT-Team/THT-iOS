//
//  BaseTargetType.swift
//  Falling
//
//  Created by Kanghos on 2023/07/10.
//

import Foundation
import Moya

public protocol BaseTargetType: TargetType { }

public extension BaseTargetType {
  var baseURL: URL {
    return URL(string: "http://tht-talk.store/")!
  }

  var headers: [String: String]? {
    return nil
//    if let accessToken = Keychain.shared.get(.accessToken) {
//      return [
//        "Authorization": "Bearer \(accessToken)",
//        "Content-Type": "application/json",
//      ]
//    } else {
//      return nil
//    }
  }
}

public extension Encodable {
  func toDictionary() -> [String: Any] {
    do {
      let data = try JSONEncoder().encode(self)
      let dic = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) as? [String: Any]

      return dic ?? [:]
    } catch {
      return [:]
    }
  }
}
