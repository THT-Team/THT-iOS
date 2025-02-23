//
//  APIError.swift
//  Falling
//
//  Created by Kanghos on 2023/07/11.
//

import Foundation

public enum APIError: Error, LocalizedError {
  case networkNotConnected
  case tokenRefreshFailed
  case withResponse(Response)
  case unknown(Error)

  public var errorDescription: String? {
    switch self {
    case .tokenRefreshFailed:
      return "인증이 만료되었습니다."
    case .networkNotConnected:
      return "네트워크 응답 없음"
    case .withResponse(let response):
      return response.message
    case .unknown(let error):
      return "알 수 없는 오류 \(error.localizedDescription)"
    }
  }
}

extension APIError {
  public struct Response: Decodable, CustomStringConvertible {
    public let timestamp: Date
    public let status: Int
    public let error: String
    public let path: String
    public let message: String?

    public var description: String {
"""
timestamp: \(timestamp)
status Code: \(status)
error: \(error)
path: \(path)
message: \(message ?? "")
"""
    }
  }
}

