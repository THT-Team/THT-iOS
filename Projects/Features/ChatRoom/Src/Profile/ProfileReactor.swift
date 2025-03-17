//
//  ProfileReactor.swift
//  ChatRoom
//
//  Created by Kanghos on 1/28/25.
//

import Foundation
import ReactorKit
import DSKit
import Domain
import ChatRoomInterface

public final class ProfileReactor: Reactor, ProfileOutput {

  // MARK: FlowOutput
  public var onDismiss: ((Bool) -> Void)?
  public var onReport: ((((Domain.UserReportAction) -> Void)?) -> Void)?
  public var handler: ProfileOutputHandler?

  // MARK: Properties
  private let userUseCase: UserDomainUseCaseInterface
  private let item: ProfileItem


  // MARK: Reactor
  public var initialState: State = State()

  public enum Action {
    case viewDidLoad
    case closeTap
    case reportTap
    case reportUser(UserReportAction)
  }

  public enum Mutation {
    case setTopic(TopicViewModel)
    case setUser(User)
    case isBlurHidden(Bool)
    case dismiss(Bool)
    case showReportAlert
  }

  public struct State {
    var section = [ProfileDetailSection]()
    var isBlurHidden: Bool = true
    var topic: TopicViewModel? = nil
  }

  public init(item: ProfileItem, userUseCase: UserDomainUseCaseInterface) {
    self.userUseCase = userUseCase
    self.item = item
  }

  deinit {
    TFLogger.cycle(name: self)
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return .concat([
        .just(.setTopic(TopicViewModel(topic: item.topic, issue: item.issue))),
        self.userUseCase.user(self.item.id)
        .asObservable()
        .map(Mutation.setUser)])
    case .closeTap:
      self.handler?(.cancel)
      return .from(
        [.dismiss(false),]
      )
    case .reportTap:
      return .concat([
        .just(.isBlurHidden(false)),
        .just(.showReportAlert)
      ])
    case let .reportUser(select):
      switch select {
      case .block:
        self.handler?(.toast("차단 당함"))
        return self.userUseCase.userReport(.block(self.item.id))
          .asObservable()
          .flatMap { _ -> Observable<Mutation> in
            return .concat([
              .just(.isBlurHidden(true)),
              .just(.dismiss(true))
            ])
          }
      case let .report(reason):
        self.handler?(.toast("신고 당함"))
        return self.userUseCase.userReport(.report(self.item.id, reason))
          .asObservable()
          .flatMap { _ -> Observable<Mutation> in
            return .concat([
              .just(.isBlurHidden(true)),
              .just(.dismiss(true))
            ])
          }
      case .cancel: return .just(.isBlurHidden(true))
      }
    }
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setTopic(topicViewModel):
      state.topic = topicViewModel
    case .setUser(let user):
      state.section = user.toProfileSection()
    case .isBlurHidden(let isHidden):
      state.isBlurHidden = isHidden
    case let .dismiss(needTransition):
      onDismiss?(needTransition)
    case .showReportAlert:
      onReport? { [weak self] select in
        self?.action.onNext(.reportUser(select))
      }
    }
    return state
  }
}
