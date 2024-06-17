//
//  LocationUseCase.swift
//  SignUpInterface
//
//  Created by Kanghos on 6/10/24.
//

import Foundation
import SignUpInterface

import RxSwift

public final class LocationUseCase: LocationUseCaseInterface {

  private var disposeBag = DisposeBag()

  private let locationService: LocationServiceType
  private let kakaoAPIService: KakaoAPIServiceType

  public init(locationService: LocationServiceType, kakaoAPIService: KakaoAPIServiceType) {
    self.locationService = locationService
    self.kakaoAPIService = kakaoAPIService
  }

  @MainActor
  public func fetchLocation() -> Single<LocationReq> { //
    self.locationService.requestLocation()
      .flatMap { [unowned self] location in
        self.kakaoAPIService.fetchLocationByCoordinate2d(longitude: location.lon, latitude: location.lat)
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
}
