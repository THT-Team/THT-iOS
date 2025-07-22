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
import Networks

final class FallingViewModel: Reactor {
  
  // MARK: Coordinator
  var onReport: ((UserReportHandler?) -> Void)?
  var onMatch: ((String, String) -> Void)?
  
  // MARK: UseCase
  private let topicUseCase: TopicUseCaseInterface
  private let fallingUseCase: FallingUseCaseInterface
  private let userDomainUseCase: UserDomainUseCaseInterface
  private let likeUseCase: LikeUseCaseInterface
  
  // MARK: Properties
  private let timer = TFTimer(startTime: 15.0)
  private let cancelFetchUserSubject = PublishSubject<Void>()
  
  let initialState = State()
  
  init(
    topicUseCase: TopicUseCaseInterface,
    fallingUseCase: FallingUseCaseInterface,
    userDomainUseCase: UserDomainUseCaseInterface,
    likeUseCase: LikeUseCaseInterface
  ) {
    self.topicUseCase = topicUseCase
    self.fallingUseCase = fallingUseCase
    self.userDomainUseCase = userDomainUseCase
    self.likeUseCase = likeUseCase
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return self.topicUseCase.getCheckIsChooseDailyTopic()
        .asObservable()
        .do(onNext: { [weak self] isChoose in
          guard let self = self else { return }
          isChoose ? self.action.onNext(.fetchUser)
          : self.action.onNext(.fetchDailyTopics)
        })
        .flatMap { _ in Observable<Mutation>.empty() }
        .catch { .just(Mutation.toast($0.localizedDescription)) }
      
    case .viewWillDisappear: return .from([.stopTimer, .showPause])
      
    case .tapTopicStart(let topicKeyword):
      return self.topicUseCase.postChoiceTopic(String(topicKeyword.index))
        .asObservable()
        .flatMap { _ -> Observable<Mutation> in
          return .from([
            .setHasChosenDailyTopic(true),
            .addTopicOrNotice(.notice(.selectedFirst, UUID())),
            .incrementIndex
          ])
        }
        .catch { .just(Mutation.toast($0.localizedDescription)) }
      
    case .fetchUser:
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
          return .from([
            .setDailyUserCursorIndex(page),
            .setRecentUserInfo(page),
            .setLoading(false),
            .applySnapshot,
            .startTimer
          ])})
      )
      .catch { .just(Mutation.toast($0.localizedDescription)) }
      
    case .selectedFirstTap, .allMetTap:
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
          if page.isLast && page.cards.count < 10 {
            return .from([
              .setLoading(false),
              .toast(
                "기다리는 무디가 아직 들어오고 있어요.\n조금 더 기다려볼까요?")])
          }
          return .from([
            .setDailyUserCursorIndex(page),
            .setRecentUserInfo(page),
            .setLoading(false),
            .addTopicOrNotice(.notice(.find, UUID())),
            .applySnapshot,
            .incrementIndex,
          ])}))
      .catch { .just(Mutation.toast($0.localizedDescription)) }
      
    case .findTap: return .from([.incrementIndex, .startTimer])
      
    case let .likeTap(user):
      return self.likeUseCase.like(
        id: user.userUUID,
        topicID: String(currentState.topicIndex)
      )
      .asObservable()
      .flatMap { match -> Observable<Mutation> in
        guard match.isMatching, let chatRoomIdx = match.chatRoomIdx else {
          return .just(.incrementIndex)
        }
        return match.isMatching ? .from([
          .toMatch(user.userProfilePhotos[0].url, String(chatRoomIdx)),
          .stopTimer])
        : .just(.incrementIndex)
      }
      .catch { .just(Mutation.toast($0.localizedDescription)) }
      
    case let .rejectTap(user):
      return self.likeUseCase.dontLike(
        id: user.userUUID,
        topicIndex: String(currentState.topicIndex)
      )
      .asObservable()
      .map { Mutation.incrementIndex }
      .catch { .just(.toast($0.localizedDescription)) }
      
    case .reportTap: return .from([.selectAlert, .stopTimer])
      
    case .pauseTap(let isPause): return isPause ? .just(.stopTimer) : .just(.startTimer)
      
    case let .deleteAnimationComplete(user):
      return .from([.removeSnapshot(user), .incrementIndex])
      
    case let .userReportAlert(select, user):
      switch select {
      case .block:
        return .concat(
          .just(.showDeleteAnimation(user)),
          self.userDomainUseCase.userReport(.block(user.userUUID))
            .asObservable()
            .map(Mutation.toast),
          .just(.hidePause),
          .just(.setHideUserInfo(true)),
          .just(.resetTimer)
        )
        
      case let .report(reason):
        return .concat(
          .just(.showDeleteAnimation(user)),
          self.userDomainUseCase.userReport(.report(user.userUUID, reason))
            .asObservable()
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
        return newState
      }
      return newState
      
    case .addTopicOrNotice(let data):
      newState.snapshot.append(data)
      return newState
      
    case .setHasChosenDailyTopic(let flag):
      UserDefaultRepository.shared.save(flag, key: .hasChosenDailyTopic)
      return newState
      
    case .setDailyUserCursorIndex(let userInfo):
      guard let index = userInfo.userInfos.last?.userDailyFallingCourserIdx else { return newState }
      newState.dailyUserCursorIndex = index
      return newState
      
    case .setRecentUserInfo(let userInfo):
      newState.userInfo = userInfo
      return newState
      
    case .incrementIndex:
      let nextIndex = newState.index + 1
      guard let _ = newState.snapshot[safe: nextIndex] else {
        timer.pause()
        return newState
      }
      newState.index = nextIndex
      newState.scrollAction = newState.indexPath
      timer.reset()
      
      guard newState.snapshot[safe: newState.index] == newState.snapshot.last,
            let _ = newState.snapshot.last?.user else { return newState }
      guard !(newState.userInfo?.isLast ?? true) else { return newState }
      self.action.onNext(.fetchUser)
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
        .map { _ in
          Mutation.incrementIndex },
      timer.seconds
        .map { Mutation.setTimeState(TimeState(rawValue: $0)) }
    )
  }
}
