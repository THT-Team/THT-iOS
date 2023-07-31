//
//  BaseTargetType.swift
//  Falling
//
//  Created by Kanghos on 2023/07/10.
//

import Foundation
import Moya

protocol BaseTargetType: TargetType { }

extension BaseTargetType {

    // Protocol Default Implementation
    var baseURL: URL {
        return URL(string: "http://tht-talk.store/")!
    }

    var headers: [String : String]? {
        let header = ["Content-Type": "application/json"]
        return header
    }
}

extension Encodable {
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
