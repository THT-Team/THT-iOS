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

public typealias DefaultUserDomainRepository = BaseRepository<UserDomainTarget>

extension DefaultUserDomainRepository: UserDomainRepositoryInterface {
  public func fetchIdealTypeEmoji() -> Single<[Domain.EmojiType]> {
    request(type: [EmojiTypeRes].self, target: .idealTypes)
      .map { $0.map { $0.toDomain() } }
  }
  
  public func fetchInterestEmoji() -> Single<[Domain.EmojiType]> {
    request(type: [EmojiTypeRes].self, target: .interests)
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
      .debug()
      .catch { error in
        if let moyaError = error as? MoyaError,
           case let .objectMapping(error, response) = moyaError {
          do {
            let result = try JSONDecoder().decode(User.Res.self, from: response.data)
          } catch {
            print(error)
          }
        }
        return .error(error)
      }
  }
}

extension EmojiTypeRes {
  func toDomain() -> EmojiType {
    EmojiType(idx: self.index, name: self.name, emojiCode: self.emojiCode)
  }
}

