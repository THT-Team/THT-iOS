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

  public init(repository: SignUpRepositoryInterface) {
    self.repository = repository
  }

  public func certificate(phoneNumber: String) -> Single<Int> {
    return repository.certificate(phoneNumber: phoneNumber)
  }

  public func checkExistence(phoneNumber: String) -> Single<Bool> {
    return repository.checkExistence(phoneNumber: phoneNumber)
      .map { $0.isSignUp }
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
    
    return repository.block()
  }
}

extension SignUpInterface.EmojiType {
  func toDomain() -> Domain.EmojiType {
    Domain.EmojiType(idx: self.index, name: self.name, emojiCode: self.emojiCode)
  }
}
