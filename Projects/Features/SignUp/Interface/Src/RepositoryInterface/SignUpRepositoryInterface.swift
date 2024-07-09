//
//  SignUpRepositoryInterface.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

import RxSwift
import AuthInterface

public protocol SignUpRepositoryInterface {
  func checkNickname(nickname: String) -> Single<Bool>
  func idealTypes() -> Single<[EmojiType]>
  func interests() -> Single<[EmojiType]>
  func signUp(_ signUpRequest: SignUpReq) -> Single<Void>
  func uploadImage(data: [Data]) -> Single<[String]>
  func fetchAgreements() -> Single<Agreement>
}
