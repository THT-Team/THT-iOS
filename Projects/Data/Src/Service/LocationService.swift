//
//  LocationService.swift
//  Data
//
//  Created by Kanghos on 5/12/24.
//

import Foundation
import CoreLocation

import SignUpInterface
import AuthInterface

import RxSwift
import Core

extension CLLocationCoordinate2D {
  func toDTO() -> LocationCoordinate2D {
    LocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}

public final class LocationService: NSObject, LocationServiceType {
  private let manager = CLLocationManager()
  public let publisher = PublishSubject<LocationCoordinate2D>()
  private let location = PublishSubject<CLLocation>()

  private var disposeBag = DisposeBag()

  public override init() {
    super.init()

    bind()
  }

  private func bind() {
    manager.delegate = self

    location
      .map(\.coordinate)
      .map { $0.toDTO() }
      .bind(to: publisher)
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

  public func requestLocation() -> Single<LocationCoordinate2D> {
    request()
      .flatMap { [unowned self] _ in
        self.publisher
          .take(1)
          .asSingle()
      }
  }

  private func request() -> Single<Void> {
    .create { [weak self] observer in
      self?.manager.requestWhenInUseAuthorization()
      
      if self?.manager.authorizationStatus == .notDetermined {
        observer(.failure(LocationError.notDetermined))
        return Disposables.create {
        }
      }

      self?.handleAuthorization { granted in
        guard granted else {
          observer(.failure(LocationError.denied))
          return
        }
//        self?.manager.requestLocation()
        self?.manager.startUpdatingLocation()
        observer(.success(()))
      }

      return Disposables.create()
    }
  }
}

extension LocationService: CLLocationManagerDelegate {
  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//    TFLogger.dataLogger.log("Location Authorization Changed: \(dump(manager.authorizationStatus.rawValue))")
  }

  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      self.location.onNext(location)
      self.manager.stopUpdatingLocation()
    }
  }

  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
  }
}
