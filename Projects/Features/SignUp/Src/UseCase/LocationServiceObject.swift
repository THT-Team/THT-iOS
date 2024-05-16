//
//  LocationService.swift
//  SignUp
//
//  Created by Kanghos on 5/5/24.
//

import Foundation
import CoreLocation
import SignUpInterface
import RxSwift


class LocationServiceObject: NSObject {
  private var manager = CLLocationManager()
  public let publisher = PublishSubject<LocationReq>()

  override init() {
    super.init()
    manager.delegate = self
  }

  func requestLocation() -> Single<Void> {
    switch manager.authorizationStatus {
    case .notDetermined:
      manager.requestWhenInUseAuthorization()
      return .just(())
    case .restricted, .denied:
      return .error(LocationError.denied)
    case .authorizedAlways, .authorizedWhenInUse:
      manager.requestLocation()
      return .just(())
    @unknown default:
      return .error(LocationError.denied)
    }
  }

  func isValid(_ location: LocationReq) -> Observable<Bool> {
    return Observable.create { observer in
      if location.lat == 0 || location.lon == 0 || location.address.isEmpty || location.regionCode == 0 {
        observer.onNext(false)
      } else {
        observer.onNext(true)
      }
      return Disposables.create()
    }
  }
}

extension LocationServiceObject: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if manager.authorizationStatus == .authorizedWhenInUse {
      manager.requestLocation()
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    publisher.onNext(location.toDomain())
  }
}

extension CLLocation {
  func toDomain() -> LocationReq {
    .init(address: "", regionCode: 0, lat: self.coordinate.latitude, lon: self.coordinate.longitude)
  }
}
