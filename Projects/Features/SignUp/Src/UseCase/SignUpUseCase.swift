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

import Core
import DSKit

public final class SignUpUseCase: SignUpUseCaseInterface {

  private let repository: SignUpRepositoryInterface
  private let fileRepository: FileRepositoryInterface

  private let contactService: ContactServiceType
  private let authService: AuthServiceType
  private let imageService: ImageServiceType

  public init(
    repository: SignUpRepositoryInterface,
    contactService: ContactServiceType,
    authService: AuthServiceType,
    fileRepository: FileRepositoryInterface,
    imageService: ImageServiceType
  ) {
    self.repository = repository
    self.fileRepository = fileRepository
    self.contactService = contactService
    self.authService = authService
    self.imageService = imageService
  }

  public func checkNickname(nickname: String) -> Single<Bool> {
    return repository.checkNickname(nickname: nickname)
  }

  public func block() -> Single<[ContactType]> {
    self.contactService.fetchContact()
      .catch { error in
        return .error(SignUpError.fetchContactsFailed(error))
      }
  }

  public func signUp(_ user: PendingUser, contacts: [ContactType]) -> Single<Void> {
    fetchUserPhotos(key: user.phoneNumber, fileNames: user.photos)
      .flatMap { [unowned self] imageData -> Single<Void> in
        self.imageService.uploadImages(imageDataArray: imageData, bucket: .profile)
          .catch({ error in
            return .error(SignUpError.imageUploadFailed)
          })
          .flatMap { [unowned self] urls in
            self.authService.signUp(user, contacts: contacts, urls: urls)
              .map { _ in }
          }
      }
  }

  public func savePendingUser(_ userInfo: PendingUser) {
    UserDefaultRepository.shared.saveModel(userInfo, key: .pendingUser)
  }

  public func fetchPendingUser() -> PendingUser? {
    UserDefaultRepository.shared.fetchModel(for: .pendingUser, type: PendingUser.self)
  }
}

// MARK: Policy
extension SignUpUseCase {
  public func fetchPolicy() -> Single<[ServiceAgreementRowViewModel]> {
    let localAgreements = UserDefaultRepository.shared.fetchModel(for: .pendingUser, type: PendingUser.self)?.userAgreements ?? [:]

    return fetchAgreements()
      .map { agreements in
        let dict = agreements.reduce(into: [String: Bool]()) {
          $0[$1.name] = false
        }.merging(localAgreements) { current, new in new }

        return agreements.map { element in
          return ServiceAgreementRowViewModel(model: element, isSelected: dict[element.name, default: false])
        }
      }
  }
  private func fetchAgreements() -> Single<Agreement> {
    repository.fetchAgreements()
  }

  public func updateMarketingAgreement(isAgree: Bool) {
    UserDefaultRepository.shared.saveModel(
      MarketingInfoAgreement(
        isAgree: isAgree,
        timeStamp: Date().toDateString()),
      key: .marketAgreement)
  }
}


// MARK: Image
extension SignUpUseCase {

  public func uploadImage(_ user: PendingUser, data: [Data]) -> Single<PendingUser> {
    imageService.uploadImages(imageDataArray: data, bucket: .profile)
      .map { urls in
        var pendingUser = user
        pendingUser.photos = urls
        return pendingUser
      }
  }

  public func processImage(_ result: PhotoItem) -> Single<Data> {
    imageService.bind(result, imageSize: .profile)
  }

  public func fetchUserPhotos(key: String, fileNames: [String]) -> Single<[Data]> {
    .create { [weak self] observer in
      guard
        let imageData = self?.fileRepository.fetch(fileNames: fileNames.map { key + "/" + $0 }),
        !imageData.isEmpty
      else {
        observer(.failure(StorageError.notExisted))
        return Disposables.create()
      }
      observer(.success(imageData))
      return Disposables.create()
    }
  }

  public func saveUserPhotos(_ user: PendingUser, datas: [Data]) -> Single<PendingUser> {
    .create { [weak self] observer in
      if let urls = self?.fileRepository.save(datas.enumerated()
        .map {
          (fileName: user.phoneNumber + "/\($0).jpeg", data: $1)
        }) {
        var pendingUser = user
        print(urls)
        pendingUser.photos = urls
        UserDefaultRepository.shared.saveModel(pendingUser, key: .pendingUser)
        observer(.success(pendingUser))
      } else {
        observer(.failure(StorageError.notExisted))
      }
      return Disposables.create()
    }
  }

  public func savePendingUser(_ user: PendingUser) -> Single<PendingUser> {
    UserDefaultRepository.shared.saveModel(user, key: .pendingUser)
    return .just(user)
  }
}
