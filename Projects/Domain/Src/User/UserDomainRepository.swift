//
//  UserDomainRepository.swift
//  Domain
//
//  Created by Kanghos on 7/27/24.
//

import Foundation

import RxSwift
import RxCocoa

public protocol UserDomainRepositoryInterface {
  func fetchIdealTypeEmoji() -> Single<[EmojiType]>
  func fetchInterestEmoji() -> Single<[EmojiType]>
  func report(id: String, reason: String) -> Single<Void>
  func block(id: String) -> Single<Void>
  func user(_ id: String) -> Single<User>
}
