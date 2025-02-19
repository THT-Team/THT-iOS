//
//  APIError.swift
//  Falling
//
//  Created by Kanghos on 2023/07/11.
//

import Foundation

public enum APIError: Error, LocalizedError {
  case networkNotConnected
  case tokenExpired(ErrorResponse)
  case invalidRequest(ErrorResponse)
  case serverError(ErrorResponse)
  case invalidResponse(String)
  case unknown(Error)

  public var errorDescription: String? {
    switch self {
    case .networkNotConnected:
      return "네트워크 응답 없음"
    case .tokenExpired(let errorResponse):
      return "로그인 에러"
    case .invalidRequest(let errorResponse):
      return "잘못된 요청: \(errorResponse.error)"
    case .serverError(let response):
      return response.description
    case .invalidResponse(let data):
      return "잘못된 응답: data"
    case .unknown(let error):
      return "알 수 없는 오류: \(error.localizedDescription)"
    }
  }
}

public struct ErrorResponse: Decodable, CustomStringConvertible {
  public let timestamp: Date
  public let status: Int
  public let error: String
  public let path: String

  public var description: String {
"""
timestamp: \(timestamp)
status Code: \(status)
error: \(error)
path: \(path)
"""
  }
}
