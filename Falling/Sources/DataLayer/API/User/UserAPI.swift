//
//  UserAPI.swift
//  Falling
//
//  Created by Kanghos on 2023/07/10.
//

import Foundation
import Moya

struct UserAPI: Networkable {
    typealias Target = UserTarget

//    static func signUp (
//        request: SignUpRequest,
//        completion: @escaping (_ response: ChatList?, _ error: Error?) -> Void
//    ){
//        makeProvider().request(.signUp(request)) { result in
//
//            switch ResponseData<ChatList>.processResponse(result) {
//            case .success(let model): return completion(model, nil)
//            case .failure(let error): return completion(nil, error)
//            }
//        }
//    }
}
