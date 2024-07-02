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

public protocol SignUpUseCaseInterface {
  func checkNickname(nickname: String) -> Single<Bool>
  func idealTypes() -> Single<[Domain.EmojiType]>
  func interests() -> Single<[Domain.EmojiType]>
  func block() -> Single<[ContactType]>
  func signUp(request: SignUpReq) -> Single<Void>
  func uploadImage(data: [Data]) -> Single<[String]>
  func fetchAgreements() -> Single<Agreement>
}
