//
//  UserTarget.swift
//  Falling
//
//  Created by Kanghos on 2023/07/10.
//

import Moya
import Foundation

enum UserTarget {

    case signUp(SignUpRequest)
}

extension UserTarget: BaseTargetType {

    var path: String {
        return "user"
    }

    var method: Moya.Method {
        return .post
    }

    // Request의 파라미터를 결정한다.
    var task: Task {
        switch self {
        case .signUp(let request) :
            return .requestParameters(parameters: request.toDictionary(),
                                      encoding: JSONEncoding.default)
        }
    }
}
