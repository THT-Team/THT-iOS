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
  }

  public func signUp(request: PendingUser, contacts: [ContactType]) -> Single<Void> {
    guard
      let deviceKey = UserDefaultRepository.shared.fetch(for: .deviceKey, type: String.self),
      let request = request.toRequest(contacts: contacts, deviceKey: deviceKey) else {
      return .error(SignUpError.invalidRequest)
    }
    return authService.signUp(request).map { _ in
      UserDefaultRepository.shared.remove(key: .pendingUser)
      UserDefaultRepository.shared.save(request.phoneNumber, key: .phoneNumber)
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
  
  public func uploadImage(data: [Data]) -> Single<[String]> {
    return imageService.uploadImages(imageDataArray: data, bucket: .profile)
  }

  public func processImage(_ result: PhotoItem) -> Single<Data> {
    imageService.bind(result, imageSize: .profile)
  }

  public func fetchUserPhotos(key: String, fileNames: [String]) -> Single<[Data]> {
    .create { [weak self] observer in
      if let imageDatas = self?.fileRepository.fetch(fileNames: fileNames.map { key + "/" + $0 }) {
        observer(.success(imageDatas))
      } else {
        observer(.failure(StorageError.notExisted))
      }
      return Disposables.create()
    }
  }

  public func saveUserPhotos(key: String, datas: [Data]) -> Single<[String]> {
    .create { [weak self] observer in
      if let urls = self?.fileRepository.save(
        datas.enumerated()
          .map { (fileName: key + "/\($0).jpeg", data: $1) }) {
        observer(.success(urls))
      } else {
        observer(.failure(StorageError.notExisted))
      }
      return Disposables.create()
    }
  }
}
