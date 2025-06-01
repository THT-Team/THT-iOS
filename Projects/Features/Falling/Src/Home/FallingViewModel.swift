//
//  FallingViewModel.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Foundation
import FallingInterface
import Domain
import ReactorKit

final class FallingViewModel: Reactor {
  
  // MARK: Coordinator
  var onReport: ((UserReportHandler?) -> Void)?
  var onMatch: ((String, String) -> Void)?
  
  // MARK: Properties
  private let topicUseCase: TopicUseCaseInterface
  private let fallingUseCase: FallingUseCaseInterface
  private let timer = TFTimer(startTime: 15.0)
  private let cancelFetchUserSubject = PublishSubject<Void>()
  
  let initialState = State()
  
  init(
    topicUseCase: TopicUseCaseInterface,
    fallingUseCase: FallingUseCaseInterface
  ) {
    self.topicUseCase = topicUseCase
    self.fallingUseCase = fallingUseCase
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      self.action.onNext(.checkIsChooseDailyTopic)
      return .empty()
      
    case .viewWillDisappear: return .from([.stopTimer, .showPause])
      
    case .selectedFirstTap: return .just(.updateIndexPath(currentState.index + 1))
      
    case .allMetTap: return .from([
      .addTopicOrNotice(.notice(.find, UUID())),
      .triggerFetchUser,
      .updateIndexPath(currentState.index + 1)])
      
    case .findTap: return .from([.updateIndexPath(currentState.index + 1), .startTimer])
      
    case let .likeTap(user):
      return self.fallingUseCase.like(userUUID: user.userUUID, topicIndex: currentState.topicIndex)
        .asObservable()
        .flatMap { match -> Observable<Mutation> in
          match.isMatched ? .from([
            .toMatch(user.userProfilePhotos[0].url, match.chatIndex),
            .stopTimer])
          : .just(.updateIndexPath(1))
        }
        .catch { .just(Mutation.toast($0.localizedDescription)) }
      
    case let .rejectTap(user):
      return self.fallingUseCase.reject(userUUID: user.userUUID, topicIndex: currentState.topicIndex)
        .asObservable()
        .map { Mutation.updateIndexPath(1) }
        .catch { .just(.toast($0.localizedDescription)) }
      
    case .reportTap: return .from([.selectAlert, .stopTimer])
      
    case .pauseTap(let isPause): return isPause ? .just(.stopTimer) : .just(.startTimer)
      
    case .checkIsChooseDailyTopic:
      return self.topicUseCase.getCheckIsChooseDailyTopic()
        .asObservable()
        .do(onNext: { [weak self] isChoose in
          guard let self = self else { return }
          isChoose ? self.action.onNext(.reloadUser) :
          self.action.onNext(.fetchDailyTopics)
        })
        .flatMap { _ in Observable<Mutation>.empty() }
        .catch { .just(Mutation.toast($0.localizedDescription)) }
      
    case .tapTopicStart(let topicKeyword):
      return self.topicUseCase.postChoiceTopic(String(topicKeyword.index))
        .asObservable()
        .do(onNext: { [weak self] _ in
          guard let self = self else { return }
          self.action.onNext(.reloadUser)
        })
        .flatMap { _ in Observable<Mutation>.empty() }
        .catch { .just(Mutation.toast($0.localizedDescription)) }
      
    case .reloadUser:
      let currentDailyIndex = currentState.dailyUserCursorIndex
      return .concat(
        .just(.setLoading(true)),
        self.fallingUseCase.user(
          alreadySeenUserUUIDList: [],
          userDailyFallingCourserIdx: currentDailyIndex,
          size: 10)
        .asObservable()
        .take(until: cancelFetchUserSubject)
        .flatMap({ page -> Observable<Mutation> in
            .from([
              .setDailyUserCursorIndex(page),
              .setRecentUserInfo(page),
              .setLoading(false),
              .applySnapshot
            ])}))
      .catch { .just(Mutation.toast($0.localizedDescription)) }
      
    case let .deleteAnimationComplete(user):
      return .from([.removeSnapshot(user), .updateIndexPath(1)])
      
    case let .userReportAlert(select, user):
      switch select {
      case .block:
        return .concat(
          .just(.showDeleteAnimation(user)),
          self.fallingUseCase.block(userUUID: user.userUUID)
            .asObservable()
            .catch { .just($0.localizedDescription) }
            .map(Mutation.toast),
          .just(.hidePause),
          .just(.setHideUserInfo(true)),
          .just(.resetTimer)
        )
        
      case let .report(reason):
        return .concat(
          .just(.showDeleteAnimation(user)),
          self.fallingUseCase.report(userUUID: user.userUUID, reason: reason)
            .asObservable()
            .catch { .just($0.localizedDescription) }
            .map(Mutation.toast),
          .just(.hidePause),
          .just(.setHideUserInfo(true)),
          .just(.resetTimer)
        )
        
      case .cancel:
        return .concat(
          .just(.hidePause),
          .just(.startTimer)
        )
      }
      
    case .closeButtonTap:
      cancelFetchUserSubject.onNext(())
      return .empty()
      
    case .fetchDailyTopics:
      return self.topicUseCase.getDailyKeyword()
        .asObservable()
        .map { Mutation.addTopicOrNotice(FallingDataModel.dailyKeyword($0)) }
        .catch({ .just(Mutation.toast($0.localizedDescription)) })
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .applySnapshot:
      newState.snapshot.append(contentsOf: newState.userInfo?.cards ?? [])
      if newState.userInfo?.isLast ?? false {
        newState.snapshot.append(.notice(.allMet, UUID()))
      }
      timer.start()
      return newState
      
    case .triggerFetchUser:
      self.action.onNext(.reloadUser)
      return newState
      
    case .addTopicOrNotice(let data):
      newState.snapshot.append(data)
      return newState
      
    case .setDailyUserCursorIndex(let userInfo):
      guard let index = userInfo.userInfos[safe: userInfo.userInfos.count - 1]?.userDailyFallingCourserIdx else { return newState }
      newState.dailyUserCursorIndex = index
      return newState
      
    case .setRecentUserInfo(let userInfo):
      newState.userInfo = userInfo
      return newState
      
    case let .updateIndexPath(offset):
      guard newState.snapshot.count - 1 > newState.index else {
        timer.pause()
        return newState
      }
      newState.index += offset
      newState.scrollAction = newState.indexPath
      timer.reset()
      
      guard newState.snapshot[safe: newState.index] == newState.snapshot.last,
            let _ = newState.snapshot.last?.user else { return newState }
      guard !(newState.userInfo?.isLast ?? true) else { return newState }
      self.action.onNext(.reloadUser)
      return newState
      
    case .selectAlert:
      self.onReport? { [weak self] select in
        guard let user = newState.user else { return }
        self?.action.onNext(.userReportAlert(select, user))
      }
      return newState
      
    case let .toMatch(url, index):
      self.onMatch?(url, index)
      return newState
      
    case let .removeSnapshot(user):
      newState.snapshot.removeAll { $0.user == user }
      return newState
      
    case let .toast(message):
      newState.toast = message
      return newState
      
    case let .showDeleteAnimation(user):
      newState.deleteAnimationUser = user
      return newState
      
    case .stopTimer:
      self.timer.pause()
      return newState
      
    case .startTimer:
      self.timer.start()
      return newState
      
    case .resetTimer:
      self.timer.reset()
      return newState
      
    case .setTimeState(let timeState):
      newState.timeState = timeState
      return newState
      
    case .setLoading(let isLoading):
      newState.isLoading = isLoading
      return newState
      
    case .hidePause:
      newState.shouldShowPause = false
      return newState
      
    case .showPause:
      newState.shouldShowPause = true
      return newState
      
    case let .setHideUserInfo(show):
      newState.hideUserInfo = show
      return newState
    }
  }
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    Observable.merge(
      mutation,
      timer.timeOut
        .map { _ in Mutation.updateIndexPath(1) },
      timer.seconds
        .map { Mutation.setTimeState(TimeState(rawValue: $0)) }
    )
  }
}
