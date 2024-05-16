//
//  SignUpRepositoryInterface.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

import RxSwift

public protocol SignUpRepositoryInterface {
  func checkNickname(nickname: String) -> Single<Bool>
  func idealTypes() -> Single<[EmojiType]>
  func interests() -> Single<[EmojiType]>
  func block(contacts: [ContactType]) -> Single<Int>
}
