//
//  LocationService.swift
//  Data
//
//  Created by Kanghos on 5/12/24.
//

import Foundation
import CoreLocation
import SignUpInterface

import RxSwift

public final class LocationService: NSObject, LocationServiceType {
  private let manager = CLLocationManager()
  private let geoCoder = CLGeocoder()
  public let publisher = PublishSubject<LocationReq>()
  private let location = PublishSubject<CLLocation>()

  private var disposeBag = DisposeBag()

  public override init() {
    super.init()

    bind()
  }

  private func bind() {
    manager.delegate = self

    location
      .map { location in
        LocationReq(address: "", regionCode: 0, lat: location.coordinate.latitude, lon: location.coordinate.longitude)
      }.bind(to: publisher)
      .disposed(by: disposeBag)
  }

  public func requestAuthorization() {
    manager.requestWhenInUseAuthorization()
  }

  public func handleAuthorization(granted: @escaping (Bool) -> Void) {
    switch manager.authorizationStatus {
    case .notDetermined:
      manager.requestWhenInUseAuthorization()
      granted(false)
    case .restricted, .denied:
      granted(false)
      location.onError(LocationError.denied)
    case .authorizedAlways, .authorizedWhenInUse:
      granted(true)
    @unknown default:
      granted(false)
    }
  }

  public func requestLocation() {
    manager.requestLocation()
  }
}

extension LocationService: CLLocationManagerDelegate {
  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

  }

  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      self.location.onNext(location)
    }
  }

  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
  }
}
