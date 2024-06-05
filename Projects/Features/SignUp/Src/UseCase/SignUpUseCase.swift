//
//  SignUpUseCase.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/1/24.
//

import Foundation
import RxSwift
import SignUpInterface
import AuthInterface
import Domain

public final class SignUpUseCase: SignUpUseCaseInterface {

  private let repository: SignUpRepositoryInterface
  private let tokenStore: TokenStore
  private let locationService: LocationServiceType
  private let kakaoAPIService: KakaoAPIServiceType
  private let contactService: ContactServiceType

  public init(repository: SignUpRepositoryInterface, locationService: LocationServiceType, kakaoAPIService: KakaoAPIServiceType, contactService: ContactServiceType, tokenStore: TokenStore) {
    self.repository = repository
    self.kakaoAPIService = kakaoAPIService
    self.contactService = contactService
    self.locationService = locationService
    self.tokenStore = tokenStore
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

  public func block() -> Single<[ContactType]> {
    self.contactService.fetchContact()
      .map { contacts in
        contacts.map { contact in
          let phoneNumber = contact.phoneNumber.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
          return ContactType(name: contact.name, phoneNumber: phoneNumber)
        }
      }
  }

  public func signUp(request: SignUpReq) -> Single<Void> {
    return repository.signUp(request)
      .flatMap { [weak self] token in
        self?.tokenStore.saveToken(token: token)
        return .just(())
      }
  }

  public func uploadImage(data: [Data]) -> Single<[String]> {
    return repository.uploadImage(data: data)
  }

  public func fetchAgreements() -> Single<Agreement> {
    repository.fetchAgreements()
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
