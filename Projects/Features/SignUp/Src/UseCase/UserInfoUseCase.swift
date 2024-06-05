//
//  UserInfoUseCase.swift
//  SignUpInterface
//
//  Created by Kanghos on 5/29/24.
//

import Foundation
import SignUpInterface
import RxSwift

public class UserInfoUseCase: UserInfoUseCaseInterface {
  private let repository: UserInfoRepositoryInterface
  
  public init(repository: UserInfoRepositoryInterface) {
    self.repository = repository
  }

  public func savePhoneNumber(_ phoneNumber: String) {
    repository.savePhoneNumber(phoneNumber)
    repository.deleteUserInfo()
  }

  public func fetchPhoneNumber() -> Single<String> {
    repository.fetchPhoneNumber()
  }

  public func fetchUserInfo() -> Single<UserInfo> {
    repository.fetchUserInfo()
  }
  
  public func updateUserInfo(userInfo: UserInfo) {
    return repository.updateUserInfo(userInfo: userInfo)
  }
  
  public func deleteUserInfo() {
    return repository.deleteUserInfo()
  }

  public func fetchUserPhotos(key: String, fileNames: [String]) -> Single<[Data]> {
    return repository.fetchUserPhotos(key: key, fileNames: fileNames)
  }

  public func saveUserPhotos(key: String, datas: [Data]) -> Single<[String]> {
    repository.saveUserPhotos(key: key, datas: datas)
  }
}
