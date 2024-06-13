//
//  LocationService.swift
//  SignUpInterface
//
//  Created by kangho lee on 4/29/24.
//

import Foundation
import RxSwift

public protocol LocationServiceType {
  var publisher: PublishSubject<LocationReq> { get }
  func handleAuthorization(granted: @escaping (Bool) -> Void)
  func requestAuthorization()
  func requestLocation() -> Single<LocationReq>
}

public enum LocationError: Error {
  case denied
  case invalidLocation
}
