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

  private let contactService: ContactServiceType

  public init(repository: SignUpRepositoryInterface, contactService: ContactServiceType) {
    self.repository = repository
    self.contactService = contactService
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
  }

  public func signUp(request: SignUpReq) -> Single<Void> {
    return repository.signUp(request)
  }

  public func uploadImage(data: [Data]) -> Single<[String]> {
    return repository.uploadImage(data: data)
  }

  public func fetchAgreements() -> Single<Agreement> {
    repository.fetchAgreements()
  }
}

extension SignUpInterface.EmojiType {
  func toDomain() -> Domain.EmojiType {
    Domain.EmojiType(idx: self.index, name: self.name, emojiCode: self.emojiCode)
  }
}
