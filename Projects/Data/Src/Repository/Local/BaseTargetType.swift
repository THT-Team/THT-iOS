//
//  BaseTargetType.swift
//  Falling
//
//  Created by Kanghos on 2023/07/10.
//
  
import Foundation
import Moya
import Core

public protocol BaseTargetType: TargetType { }

public extension BaseTargetType {
  var baseURL: URL {
    return URL(string: "http://tht-talk.co.kr/")!
  }
  
  var headers: [String: String]? {
    if let accessToken =  UserDefaultTokenStore().getToken()?.accessToken {
      return [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(accessToken)"
      ]
    } else {
      return [
        "Content-Type": "application/json"
      ]
    }
  }

  var validationType: ValidationType {
    return.customCodes(Array(200..<500).filter { $0 != 401 })
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
