//
//  UserInfoUseCase2.swift
//  SignUp
//
//  Created by Kanghos on 7/3/24.
//

import Foundation

import Core
import SignUpInterface
import RxSwift

public enum StorageError: Error {
  case notExisted
}

public class UserInfoUseCase: UserInfoUseCaseInterface {
  private let fileRepository: FileRepositoryInterface

  public init(fileRepository: FileRepositoryInterface) {
    self.fileRepository = fileRepository
  }

  public func savePhoneNumber(_ phoneNumber: String) {
    UserDefaultRepository.shared.save(phoneNumber, key: .phoneNumber)
    deleteUserInfo()
  }

  public func fetchPhoneNumber() -> Single<String> {
    Single<String>.create { observer in
      if let phoneNumber = UserDefaultRepository.shared.fetch(for: .phoneNumber, type: String.self) {
        observer(.success(phoneNumber))
      } else {
        observer(.failure(StorageError.notExisted))
      }
      return Disposables.create { }
    }
  }

  public func fetchUserInfo() -> Single<UserInfo> {
    .create { observer in
      if let userInfo = UserDefaultRepository.shared.fetchModel(for: .pendingUser, type: UserInfo.self) {
        observer(.success(userInfo))
      } else {
        observer(.failure(StorageError.notExisted))
      }
      return Disposables.create()
    }
  }

  public func updateUserInfo(userInfo: UserInfo) {
    UserDefaultRepository.shared.saveModel(userInfo, key: .pendingUser)
  }

  public func deleteUserInfo() {
    UserDefaultRepository.shared.remove(key: .pendingUser)
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

  public func updateMarketingAgreement(isAgree: Bool) {
    UserDefaultRepository.shared.saveModel(
      MarketingInfoAgreement(
        isAgree: isAgree,
        timeStamp: Date().toDateString()),
      key: .marketAgreement)
  }
}
