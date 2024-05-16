//
//  SignUpUseCase.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/1/24.
//

import Foundation
import RxSwift
import SignUpInterface
import Domain

public final class SignUpUseCase: SignUpUseCaseInterface {

  private let repository: SignUpRepositoryInterface
  private let locationService: LocationServiceType
  private let kakaoAPIService: KakaoAPIServiceType
  private let contactService: ContactServiceType

  public init(repository: SignUpRepositoryInterface, locationService: LocationServiceType, kakaoAPIService: KakaoAPIServiceType, contactService: ContactServiceType) {
    self.repository = repository
    self.kakaoAPIService = kakaoAPIService
    self.contactService = contactService
    self.locationService = locationService
  }

  public func checkNickname(nickname: String) -> Single<Bool> {
    return repository.checkNickname(nickname: nickname)
  }

  public func idealTypes() -> Single<[Domain.EmojiType]> {
    return repository.idealTypes()
      .catchAndReturn([])
      .map { $0.map { $0.toDomain() }}
  }

  public func interests() -> Single<[Domain.EmojiType]> {
    return repository.interests()
      .catchAndReturn([])
      .map { $0.map { $0.toDomain() }}
  }

  public func block() -> Single<Int> {
    self.contactService.fetchContact()
      .flatMap { [unowned self] contacts in
        self.repository.block(contacts: contacts)
      }
  }

  @MainActor
  public func fetchLocation() -> Single<LocationReq> { //
    self.locationService.requestAuthorization()
    self.locationService.handleAuthorization { [weak self] granted in
      guard granted else {
        return
      }
      self?.locationService.requestLocation()
    }

    return self.locationService.publisher
      .take(1)
      .asSingle()
      .flatMap { [unowned self] locationReq in
        self.kakaoAPIService.fetchLocationByCoordinate2d(longitude: locationReq.lon, latitude: locationReq.lat)
      }.map { model in
        guard let model else {
          throw LocationError.invalidLocation
        }
        return model
      }
  }

  public func fetchLocation(_ address: String) -> Single<LocationReq> {
    self.kakaoAPIService.fetchLocationByAddress(address: address)
      .map { model in
        guard let model else {
          throw LocationError.invalidLocation
        }
        return model
      }
  }
}

extension SignUpInterface.EmojiType {
  func toDomain() -> Domain.EmojiType {
    Domain.EmojiType(idx: self.index, name: self.name, emojiCode: self.emojiCode)
  }
}
