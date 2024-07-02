//
//  UserDomainRepository.swift
//  Data
//
//  Created by Kanghos on 7/27/24.
//

import Foundation
import Domain

import Networks
import SignUpInterface

import RxSwift
import RxMoya
import Moya

import Core

public final class DefaultUserDomainRepository: ProviderProtocol {
  public typealias Target = UserDomainTarget
  public var provider: MoyaProvider<Target>

  public init() {
    self.provider = Self.makeStubProvider()
  }
}

extension DefaultUserDomainRepository: UserDomainRepositoryInterface {
  public func fetchIdealTypeEmoji() -> Single<[Domain.EmojiType]> {
    request(type: [EmojiTypeRes].self, target: .idealTypes)
      .map { $0.map { $0.toDomain() } }
  }
  
  public func fetchInterestEmoji() -> Single<[Domain.EmojiType]> {
    request(type: [EmojiTypeRes].self, target: .interests)
      .map { $0.map { $0.toDomain() } }
  }
}

extension EmojiTypeRes {
  func toDomain() -> EmojiType {
    EmojiType(idx: self.index, name: self.name, emojiCode: self.emojiCode)
  }
}

