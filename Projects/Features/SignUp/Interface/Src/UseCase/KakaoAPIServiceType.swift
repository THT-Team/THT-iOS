//
//  KakaoAPIServiceType.swift
//  SignUpInterface
//
//  Created by Kanghos on 5/14/24.
//

import Foundation

import RxSwift

public protocol KakaoAPIServiceType {
  func fetchLocationByCoordinate2d(longitude: Double, latitude: Double) -> Single<LocationReq?>
  func fetchLocationByAddress(address: String) -> Single<LocationReq?>
}
