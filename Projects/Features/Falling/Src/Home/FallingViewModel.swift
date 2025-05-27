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

  func mutate(action: Action) async -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      self.action.onNext(.checkIsChooseDailyTopic)
      return .empty()
    case .viewWillDisappear: return .from([.stopTimer, .showPause])
    case .selectedFirstTap: return .from([.triggerFetchUser, .updateIndexPath(1)])
      
    case .allMetTap: return .from([
      .addUser([.notice(.find, UUID())]),
      .triggerFetchUser,
      .updateIndexPath(1)])
    case .findTap: return .from([.startTimer, .updateIndexPath(1)])
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
        .map{ Mutation.updateIndexPath(1) }
        .catch { .just(.toast($0.localizedDescription)) }
    case .reportTap: return .from([.selectAlert, .stopTimer])
    case .pauseTap(let isPause): return isPause ? .just(.stopTimer) : .just(.startTimer)
      
    case .checkIsChooseDailyTopic:
      return self.topicUseCase.getCheckIsChooseDailyTopic()
        .asObservable()
        .flatMapLatest { isChoose -> Observable<Mutation> in
            return .concat([
              .just(.setIsChooseDailyTopic(isChoose)),
              Observable.deferred { [weak self] in
                guard let self = self else { return .empty() }
                isChoose ? self.action.onNext(.reloadUser) :  self.action.onNext(.fetchDailyTopics)
                return .empty()
              }
            ])
        }
        
    case .topicTap(let topicKeyword): break
      
    case .reloadUser:
      let currentDailyIndex = currentState.dailyUserCursorIndex
      return .concat(
        .just(.setLoading(true)),
        self.fallingUseCase.user(
          alreadySeenUserUUIDList: [],
          userDailyFallingCourserIdx: currentDailyIndex,
          size: 5)
        .asObservable()
        .take(until: cancelFetchUserSubject)
        .flatMap({ page -> Observable<Mutation> in
            .from([
              .setRecentUserInfo(page),
              .setLoading(false),
              .applySnapshot,
            ])}))
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
            .map { Mutation.toast($0) },
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
            .map { Mutation.toast($0) },
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
        self.topicUseCase.getDailyKeyword()
          .asObservable()
          .map { Mutation.addTopics(FallingDataModel.dailyKeyword($0)) }
          .catch { error in
            .just(.toast(error.localizedDescription))
          }
    }
    return .empty()
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .applySnapshot:
      newState.snapshot.append(contentsOf: newState.userInfo?.cards ?? [])
      if newState.userInfo?.isLast ?? false { // Server값: 마지막 유저이면 미리 카드 넣어두기
        newState.snapshot.append(.notice(.allMet, UUID()))
      }
      return newState
    case .triggerFetchUser:
      self.action.onNext(.reloadUser)
      return newState
    case .addFirstMetNoticeCard: // TODO: 토픽 로직
      if !newState.isChooseDailyTopic { // 처음
        newState.snapshot = [.notice(.selectedFirst, UUID()),
                             .notice(.find, UUID())]
        newState.dailyUserCursorIndex = 0
      }
      return newState
    case .addTopics(let dailyKeyword):
      newState.snapshot.append(dailyKeyword)
      return newState
    case .addUser(let userInfos):
      newState.snapshot += userInfos
      timer.start()
      return newState
    case let .setRecentUserInfo(userInfo):
      let users = userInfo.userInfos
      if users.count > 0 {
        newState.dailyUserCursorIndex = users[users.count - 1].userDailyFallingCourserIdx
      }
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

      // 마지막 카드가 보일 때, reload
      if newState.index % newState.snapshot.count == newState.snapshot.count - 1 {
        guard !(newState.userInfo?.isLast ?? false) else { return newState }
        self.action.onNext(.reloadUser)
      }
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
    case .setIsChooseDailyTopic(let isChoose):
      newState.isChooseDailyTopic = isChoose
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
