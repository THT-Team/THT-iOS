//
//  KakaoAPITarget.swift
//  Data
//
//  Created by Kanghos on 5/12/24.
//

import Foundation

import Networks

import Moya

public enum KakaoAPITarget {
  case searchAddress(query: String)
  case searchCoordinate(longitude: Double, latitude: Double)
}

extension KakaoAPITarget: BaseTargetType {

  public var baseURL: URL {
    URL(string: "https://dapi.kakao.com")!
  }

  public var path: String {
    switch self {
    case .searchAddress:
      return "/v2/local/search/address.json"
    case .searchCoordinate:
      return "/v2/local/geo/coord2regioncode.json"
    }
  }

  public var headers: [String : String]? {
    ["Authorization": "KakaoAK fd26fcdea335b93122163284d3fd4047"]
  }

  public var method: Moya.Method {
    switch self {
    default: return .get
    }
  }

  var parameters: [String: Any] {
    switch self {
    case .searchAddress(let query):
      return ["query": query]
    case .searchCoordinate(let longitude, let latitude):
      return ["x": longitude, "y": latitude]
    }
  }

  // Request의 파라미터를 결정한다.
  public var task: Task {
    switch self {
    case.searchAddress:
      return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    case .searchCoordinate:
      return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }
  }
}
