//
//  ErrorMapper.swift
//  Networks
//
//  Created by Kanghos on 2/20/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation

import Core

import Moya
import Alamofire

struct ErrorMaper {
  static func map(_ error: Error) -> APIError {
    guard case let MoyaError.underlying(error, response) = error,
          let data = response?.data else {
      return APIError.unknown(error)
    }
    // Case 401 Refresh failed
    if case let AFError.requestAdaptationFailed(adaptError) = error,
       let authError = adaptError as? AuthenticationError {
      return APIError.tokenRefreshFailed
    } else if case let AFError.requestRetryFailed(retryError, _) = error,
              let authError = retryError as? AuthenticationError {
      return APIError.tokenRefreshFailed
    } else {
      do {
        let errorResponse = try JSONDecoder.customDeocder.decode(APIError.Response.self, from: data)
        return APIError.withResponse(errorResponse)
      } catch {
        return APIError.unknown(error)
      }
    }
  }
}
