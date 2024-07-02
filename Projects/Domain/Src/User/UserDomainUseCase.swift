//
//  UserDomainUseCase.swift
//  Domain
//
//  Created by Kanghos on 7/27/24.
//

import Foundation

import RxSwift
import RxCocoa

public enum DomainType {
  case idealType
  case interest
}

public protocol UserDomainUseCaseInterface {
  func fetchEmoji(initial: [Int], type: DomainType) -> Single<[InputTagItemViewModel]>
}

public final class DefaultUserDomainUseCase: UserDomainUseCaseInterface {
  private let repository: UserDomainRepositoryInterface

  public init(repository: UserDomainRepositoryInterface) {
    self.repository = repository
  }

  public func fetchEmoji(initial: [Int], type domain: DomainType) -> Single<[InputTagItemViewModel]> {
    let emoji: Single<[EmojiType]>

    switch domain {
    case .idealType:
      emoji = repository.fetchIdealTypeEmoji()
    case .interest:
      emoji = repository.fetchInterestEmoji()
    }
    return emoji
      .map { $0.map { InputTagItemViewModel(item: $0, isSelected: false) }}
      .map { remote in
        var mutable = remote
        initial.forEach { index in
          if let index = mutable.firstIndex(where: { $0.emojiType.idx == index }) {
            mutable[index].isSelected = true
          }
        }
        return mutable
      }
  }
}
