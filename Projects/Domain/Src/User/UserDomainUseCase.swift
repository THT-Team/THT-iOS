//
//  UserDomainUseCase.swift
//  Domain
//
//  Created by Kanghos on 7/27/24.
//

import Foundation

import RxSwift

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
    private let tokenService: TokenServiceType

    public init(
        repository: UserDomainRepositoryInterface,
        tokenService: TokenServiceType
    ) {
    self.repository = repository
    self.tokenService = tokenService
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
        return repository.block(id: id)
          .map { _ in "차단하기가 완료되었습니다.\n해당 사용자와 서로 차단됩니다." }
          .catch { _ in .just("차단하기에 실패했습니다. 다시 시도해주세요.") }
    case let .blockUsers(ids):
      guard let target = ids.first(where: { $0 != tokenService.getToken()?.userUuid }) else {
            return .just("차단하기에 실패했습니다. 다시 시도해주세요.")
        }
      return repository.block(id: target)
        .map { _ in "차단하기가 완료되었습니다.\n해당 사용자와 서로 차단됩니다." }
        .catch { _ in .just("차단하기에 실패했습니다. 다시 시도해주세요.") }
        
    case let .report(id, reason):
        return repository.report(id: id, reason: reason)
          .map { _ in "신고하기가 완료되었습니다. 해당 사용자와\n서로 차단되며, 신고 사유는 검토 후 처리됩니다." }
          .catch { _ in .just("신고하기에 실패했습니다. 다시 시도해주세요.") }
    case let .reportUsers(ids, reason):
      guard let target = ids.first(where: { $0 != tokenService.getToken()?.userUuid }) else {
         return .just("신고하기에 실패했습니다. 다시 시도해주세요.")
      }
      return repository.report(id: target, reason: reason)
        .map { _ in "신고하기가 완료되었습니다. 해당 사용자와\n서로 차단되며, 신고 사유는 검토 후 처리됩니다." }
        .catch { _ in .just("신고하기에 실패했습니다. 다시 시도해주세요.") }
    }
  }

  public func user(_ id: String) -> Single<User> {
    repository.user(id)
  }
}
