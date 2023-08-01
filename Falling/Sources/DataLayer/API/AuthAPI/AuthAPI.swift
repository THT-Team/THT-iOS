//
//  AuthAPI.swift
//  Falling
//
//  Created by Kanghos on 2023/08/01.
//

import Foundation

struct AuthAPI: Networkable {
  typealias Target = AuthTarget

  static func signUpRequest(request: SignUpRequest, completion: @escaping (Result<SignUpResponse?, Error>) -> Void) {
    makeProvider().request(.signup(request: request)) { result in
      switch ResponseData<SignUpResponse>.processResponse(result) {
      case .success(let model): return completion(.success(model))
      case .failure(let error): return completion(.failure(error))
      }
    }
  }
}
