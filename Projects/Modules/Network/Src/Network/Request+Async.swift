//
//  Request+Async.swift
//  Networks
//
//  Created by Kanghos on 2/20/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation

import Moya

// MARK: Async

extension ProviderProtocol {
  func request<D: Decodable>(target: Target, completion: @escaping (Result<D, Error>) -> Void) {
    provider.request(target) { result in
      switch result {
      case let .success(response):
        let decoder = JSONDecoder()
        do {
          let model = try decoder.decode(D.self, from: response.data)
          completion(.success(model))
        } catch {
          completion(.failure(error))
        }
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }

  public func request<D: Decodable>(target: Target) async throws -> D {
    try await withCheckedThrowingContinuation { continuation in
      provider.request(target) { result in
        switch result {
        case let .success(response):
          do {
            let model = try JSONDecoder.customDeocder.decode(D.self, from: response.data)
            continuation.resume(returning: model)
          } catch {
            continuation.resume(throwing: error)
          }
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
