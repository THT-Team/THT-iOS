//
//  SignUpUseCase.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

import RxSwift
import Core

public protocol SignUpUseCaseInterface {
  func checkNickname(nickname: String) -> Single<Bool>

  // MARK: Policy
  func fetchPolicy() -> Single<[ServiceAgreementRowViewModel]>
  func updateMarketingAgreement(isAgree: Bool)

  // MARK: Storage
  func fetchPendingUser() -> PendingUser?
  func savePendingUser(_ userInfo: PendingUser)


  func block() -> Single<[ContactType]>
  func signUp(_ user: PendingUser, contacts: [ContactType]) -> Single<Void>
  
  // MARK: Photo
  func fetchUserPhotos(key: String, fileNames: [String]) -> Single<[Data]>

  func saveUserPhotos(_ user: PendingUser, datas: [Data]) -> Single<PendingUser>

  func processImage(_ result: PhotoItem) -> Single<Data>

  func fetchEmoji(initial: [Int], type domain: DomainType) -> Single<[InputTagItemViewModel]>
}
