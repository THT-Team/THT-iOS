//
//  LocationUseCase.swift
//  SignUpInterface
//
//  Created by Kanghos on 6/10/24.
//

import Foundation
import SignUpInterface
import AuthInterface

import RxSwift

public final class LocationUseCase: LocationUseCaseInterface {

  private var disposeBag = DisposeBag()

  private let locationService: LocationServiceType
  private let kakaoAPIService: KakaoAPIServiceType

  public init(locationService: LocationServiceType, kakaoAPIService: KakaoAPIServiceType) {
    self.locationService = locationService
    self.kakaoAPIService = kakaoAPIService
  }

  public func fetchLocation() -> Single<LocationReq> { //
    self.locationService.requestLocation()
      .debug("fetched from GPS")
      .flatMap { [unowned self] location in
        self.kakaoAPIService.fetchLocationByCoordinate2d(longitude: location.longitude, latitude: location.latitude)
      }.map { location in
        guard let location else {
          throw LocationError.invalidLocation
        }
        return location
      }
  }

  public func fetchLocation(address: String) -> Single<LocationReq> {
    self.kakaoAPIService.fetchLocationByAddress(address: address)
      .map { model in
        guard let model else {
          throw LocationError.invalidLocation
        }
        return model
      }
  }

  public func isValid(_ location: LocationReq?) -> Single<Bool> {
    guard
      let location,
      location.address.isEmpty == false,
      location.lat != 0, location.lon != 0
    else { return .just(false) }
    return .just(true)
  }
}
