//
//  LocationService.swift
//  SignUpInterface
//
//  Created by kangho lee on 4/29/24.
//

import Foundation
import RxSwift

import AuthInterface

public protocol LocationServiceType {
  var publisher: PublishSubject<LocationCoordinate2D> { get }
  func handleAuthorization(granted: @escaping (Bool) -> Void)
  func requestAuthorization()
  func requestLocation() -> Single<LocationCoordinate2D>
}

public enum LocationError: Error {
  case denied
  case invalidLocation
  case notDetermined
}

public struct LocationCoordinate2D {
  public let latitude: Double
  public let longitude: Double

  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
}
