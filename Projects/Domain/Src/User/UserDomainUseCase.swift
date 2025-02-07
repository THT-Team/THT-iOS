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
  func userReport(_ action: UserReportType) -> Single<String>
  func user(_ id: String) -> Single<User>
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

  public func userReport(_ action: UserReportType) -> Single<String> {
    switch action {
    case let .block(id):
      repository.block(id: id)
        .map { _ in "차단하기가 완료되었습니다.\n해당 사용자와 서로 차단됩니다." }
    case let .report(id, reason):
      repository.report(id: id, reason: reason)
        .map { _ in "신고하기가 완료되었습니다. 해당 사용자와\n서로 차단되며, 신고 사유는 검토 후 처리됩니다." }
    }
  }

  public func user(_ id: String) -> Single<User> {
    repository.user(id)
  }
}
