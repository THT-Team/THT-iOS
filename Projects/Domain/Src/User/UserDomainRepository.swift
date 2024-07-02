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
}
