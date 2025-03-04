//
//  UserDomainRepository.swift
//  Data
//
//  Created by Kanghos on 7/27/24.
//

import Foundation
import Domain

import Networks

import RxSwift
import RxMoya
import Moya

import Core

public typealias DefaultUserDomainRepository = BaseRepository<UserDomainTarget>

extension DefaultUserDomainRepository: UserDomainRepositoryInterface {
  public func fetchIdealTypeEmoji() -> Single<[Domain.EmojiType]> {
    request(type: [EmojiType.Res].self, target: .idealTypes)
      .map { $0.map { $0.toDomain() } }
  }
  
  public func fetchInterestEmoji() -> Single<[Domain.EmojiType]> {
    request(type: [EmojiType.Res].self, target: .interests)
      .map { $0.map { $0.toDomain() } }
  }

  public func report(id: String, reason: String) -> Single<Void> {
    requestWithNoContent(target: .report(id, reason))
  }

  public func block(id: String) -> Single<Void> {
    requestWithNoContent(target: .block(id))
  }

  public func user(_ id: String) -> Single<User> {
    request(type: User.Res.self, target: .user(id))
      .map { $0.toDomain() }
  }
}

extension EmojiType {
  public struct Res: Codable {
    public let index: Int
    public let name: String
    public let emojiCode: String

    enum CodingKeys: String, CodingKey {
      case index = "idx"
      case name, emojiCode
    }

    public init(index: Int, name: String, emojiCode: String) {
      self.index = index
      self.name = name
      self.emojiCode = emojiCode
    }

    func toDomain() -> EmojiType {
      EmojiType(idx: self.index, name: self.name, emojiCode: self.emojiCode)
    }
  }
}

