//
//  SignUpUseCase.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

import RxSwift
import Domain

public protocol SignUpUseCaseInterface {
  func certificate(phoneNumber: String) -> Single<Int>
  func checkExistence(phoneNumber: String) -> Single<Bool>
  func checkNickname(nickname: String) -> Single<Bool>
  func idealTypes() -> Single<[Domain.EmojiType]>
  func interests() -> Single<[Domain.EmojiType]>
  func block() -> Single<Int>
}
