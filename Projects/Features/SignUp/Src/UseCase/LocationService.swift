//
//  File.swift
//  SignUpInterface
//
//  Created by kangho lee on 4/29/24.
//

import Foundation
import CoreLocation
import SignUpInterface

import RxSwift

final class LocationService: NSObject, LocationServiceType {
  private let manager = CLLocationManager()
  private let geoCoder = CLGeocoder()
  public let publisher = PublishSubject<String>()
  
  public override init() {
    super.init()
    
    manager.delegate = self
  }
  
  func requestAuthorization() {
    manager.requestWhenInUseAuthorization()
  }
  
  func handleAuthorization(granted: @escaping (Bool) -> Void) {
    switch manager.authorizationStatus {
    case .notDetermined:
      manager.requestWhenInUseAuthorization()
      granted(false)
    case .restricted, .denied:
      granted(false)
    case .authorizedAlways, .authorizedWhenInUse:
      granted(true)
    @unknown default:
      granted(false)
    }
  }
  
  func requestLocation() {
    manager.requestLocation()
  }
  
  private func convertToAddress(location: CLLocation) {
    geoCoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
      guard let placemark = placemarks?.last else { return }
      guard let locality = placemark.locality,
            let subLocality = placemark.subLocality,
            let thoroughfare = placemark.thoroughfare else { return }
      let address = "\(locality) \(subLocality) \(thoroughfare)"
      self?.publisher.onNext(address)
    }
  }
}

extension LocationService: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    handleAuthorization() { _ in }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      convertToAddress(location: location)
    }
  }
}
