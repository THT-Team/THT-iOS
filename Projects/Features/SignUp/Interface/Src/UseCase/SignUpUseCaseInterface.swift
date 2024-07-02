//
//  SignUpUseCase.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

import RxSwift
import Domain

import AuthInterface
import PhotosUI

public protocol SignUpUseCaseInterface {
  func checkNickname(nickname: String) -> Single<Bool>

//  func fetchIdealTypeEmoji() -> Single<[Domain.InputTagItemViewModel]>
//  func fetchInterestEmoji() -> Single<[Domain.InputTagItemViewModel]>

  // MARK: Policy
  func fetchPolicy() -> Single<[ServiceAgreementRowViewModel]>
  func updateMarketingAgreement(isAgree: Bool)

  // MARK: Storage
  func fetchPendingUser() -> PendingUser?
  func savePendingUser(_ userInfo: PendingUser)


  func block() -> Single<[ContactType]>
  func signUp(request: PendingUser, contacts: [ContactType]) -> Single<Void>
  
  // MARK: Photo
  func fetchUserPhotos(key: String, fileNames: [String]) -> Single<[Data]>
  func saveUserPhotos(key: String, datas: [Data]) -> Single<[String]>
  func uploadImage(data: [Data]) -> Single<[String]>
  func processImage(_ result: PHPickerResult) -> Single<Data>
}
