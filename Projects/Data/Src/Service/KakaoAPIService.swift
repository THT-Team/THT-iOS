//
//  KakaoAPIService.swift
//  Data
//
//  Created by Kanghos on 5/12/24.
//

import Foundation

import Networks
import Domain

import Moya
import RxSwift

public typealias KakaoAPIService = BaseProvider<KakaoAPITarget>

extension KakaoAPIService: KakaoAPIServiceType {  
  public func fetchLocationByAddress(address: String) -> Single<LocationReq?> {
    request(type: KakaoSearchRes.self, target: .searchAddress(query: address))
      .map { $0.toDomain() }
  }

  public func fetchLocationByCoordinate2d(longitude: Double, latitude: Double) -> Single<LocationReq?> {
    request(type: KakaoCoordinateRes.self, target: .searchCoordinate(longitude: longitude, latitude: latitude))
      .map { $0.toDomain() }
  }
}
