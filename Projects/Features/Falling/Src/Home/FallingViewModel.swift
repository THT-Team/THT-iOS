//
//  FallingViewModel.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Core
import FallingInterface

import RxSwift
import RxCocoa
import Foundation
import Domain

import ReactorKit

final class FallingViewModel: Reactor {

  // MARK: Coordinator
  var onReport: ((UserReportHandler?) -> Void)?
  var onMatch: ((String, String) -> Void)?

  private let fallingUseCase: FallingUseCaseInterface

  var disposeBag: DisposeBag = DisposeBag()

  private let timer = TFTimer(startTime: 15.0)

  init(fallingUseCase: FallingUseCaseInterface) {
    self.fallingUseCase = fallingUseCase
  }

  enum Action {
    case viewDidLoad
    case viewWillDisappear
    case cellButtonAction(UserCardType)
    case deleteAnimationComplete(FallingUser)
    case noticeButtonAction(NoticeCardType)
    case userReportAlert(UserReportAction)

    case fetchUser(currentIndex: Int)
  }

  let initialState = State()
  let scrollCommand = PublishRelay<ScrollAction>()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return .just(.addFirstMetNoticeCard)
    case .noticeButtonAction(let noticeAction):
      switch noticeAction {
      case .selectedFirst:
        return .from([.triggerFetchUser, .updateIndexPath(1)])
      case .allMet:
        return .from([.addUser([.notice(.find, UUID())]), .triggerFetchUser, .updateIndexPath(1)])
      case .find:
        return .from([.startTimer, .updateIndexPath(1)])
      }
    case .viewWillDisappear:
      return .from([.stopTimer, .showPause])
    case .cellButtonAction(let cellAction): // FIXME: cell로 부터 값 받아오기 또는 Reactor 끼리 연결
      guard let user = self.currentState.user else { return .empty() }
      switch cellAction {
      case .likeTap:
        return self.fallingUseCase.like(userUUID: user.userUUID, topicIndex: currentState.topicIndex)
          .asObservable()
          .flatMap({ response -> Observable<Mutation> in
            if response.isMatched {
              return .concat(
                .just(.toMatch(user.userProfilePhotos[0].url, response.chatIndex)),
                .just(.stopTimer)
              )
            }
            return .concat (
              .just(.updateIndexPath(1))
            )
          })
          .catch { .concat(.just(.toast($0.localizedDescription)))}
      case .rejectTap:
        return self.fallingUseCase.reject(userUUID: user.userUUID, topicIndex: currentState.topicIndex)
          .asObservable()
          .flatMap { _ -> Observable<Mutation> in
            return .concat (
              .just(.updateIndexPath(1))
            )
          }
          .catch { .concat(
            .just(.toast($0.localizedDescription))
          )}
      case .reportTap: return .from([
        .selectAlert, .stopTimer
      ])
      case .pause(let shouldPause): return shouldPause ? .just(.stopTimer) : .just(.startTimer)
      }
    case let .fetchUser(currentDailyIndex):
      return .concat(
        .just(.setLoading(true)),
        self.fallingUseCase.user(
          alreadySeenUserUUIDList: [],
          userDailyFallingCourserIdx: currentDailyIndex,
          size: 5)
        .retry(when: { errorObservable in
          errorObservable
            .enumerated()
            .flatMap { attempt, error in
              attempt < 2
              ? Observable<Int>.just(attempt).delay(.seconds(3), scheduler: MainScheduler.instance)
              : Observable.error(error)
            }
        })
        .delay(.milliseconds(700), scheduler: MainScheduler())
        .asObservable()
        .flatMap({ userinfo -> Observable<Mutation> in
            .from([
              .setRecentUserInfo(userinfo),
              .setLoading(false),
              .applySnapshot,
            ])})
      )
    case let .deleteAnimationComplete(user):
      return .from([.removeSnapshot(user), .setScrollEvent(.scroll)])

      // MARK: Handle Report Alert Action
    case let .userReportAlert(select):
      guard let user = self.currentState.user else { return .empty() }
      switch select {
      case .block:
        return .concat(
          .just(.setScrollEvent(.scrollAfterDelete(user))),
          self.fallingUseCase.block(userUUID: user.userUUID)
            .asObservable()
            
            .catch { .just($0.localizedDescription) }
            .map { Mutation.toast($0) },
          .just(.resetTimer)
        )
      case let .report(reason):
        return .concat(
          .just(.setScrollEvent(.scrollAfterDelete(user))),
          self.fallingUseCase.report(userUUID: user.userUUID, reason: reason)
            .asObservable()
            .catch { .just($0.localizedDescription) }
            .map { Mutation.toast($0) },
          .just(.resetTimer)
        )
      case .cancel: return .just(.startTimer)
      }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .applySnapshot:
      newState.snapshot.append(contentsOf: newState.userInfo.userInfos.map { FallingDataModel.fallingUser($0) })
      if newState.userInfo.isLast { // Server값: 마지막 유저이면 미리 카드 넣어두기
        newState.snapshot.append(.notice(.allMet, UUID()))
      }
      return newState
    case .triggerFetchUser:
      self.action.onNext(.fetchUser(currentIndex: newState.dailyUserCursorIndex))
      return newState
    case .addFirstMetNoticeCard:
      if !newState.isAlreadyTopicSelected { // 처음
        newState.snapshot = [.notice(.selectedFirst, UUID()), .notice(.find, UUID())]
        newState.dailyUserCursorIndex = 0
      }
      return newState

    case let .addUser(userInfos):
      newState.snapshot += userInfos
      timer.start()
      return newState

    case let .setRecentUserInfo(userInfo):
      let users = userInfo.userInfos
      newState.dailyUserCursorIndex = users[users.count - 1].userDailyFallingCourserIdx
      newState.userInfo = userInfo
      return newState


    case let .updateIndexPath(offset):
      if newState.snapshot.count - 1 > newState.index {
        newState.index += offset
        newState.scrollAction = .scroll(newState.indexPath)
        timer.reset()

        // 마지막 카드이면? 아래 조건식 이해 필요
        if newState.index % newState.snapshot.count == newState.snapshot.count - 1 {
          guard !newState.userInfo.isLast else {
            return newState
          }
          timer.pause()
          self.action.onNext(.fetchUser(currentIndex: newState.dailyUserCursorIndex))
        }
      } else {
        timer.pause()
      }
      return newState

    case .selectAlert:
      self.onReport? { [weak self] select in
        self?.action.onNext(.userReportAlert(select))
      }
      return newState

    case let .toMatch(url, index):
      self.onMatch?(url, index)
      return newState

    case let .removeSnapshot(user):
      newState.snapshot.removeAll(where: {
        switch $0 {
        case .fallingUser(let userData):
          user == userData
        default: false
        }
      })
      return newState
    case let .toast(message):
      newState.toast = message
      return newState
    case let .setScrollEvent(action):
      switch action {
      case .pause:
        newState.scrollAction = .pause
      case .scroll:
        if let _ = newState.user {
          newState.scrollAction = .scroll(newState.indexPath)
        }
        return newState
      case .scrollAfterDelete(let user):
        newState.scrollAction = .scrollAfterDelete(user)
      }
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
    default: return newState
    }
  }
}

extension FallingViewModel {
  // MARK: 외부 서비스 응답받을 때만 사용
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let timerShare = timer.currentTime
      .share()
    let timeOut = timerShare
      .filter { $0 == .zero }
      .flatMap { _ -> Observable<Mutation> in
          .concat(
            .just(.updateIndexPath(1))
          )
      }
    let timeStateMutation = timerShare
      .map { TimeState(rawValue: $0) }
      .map { Mutation.setTimeState($0) }

    return Observable.merge(
      mutation,
      timeStateMutation, timeOut)
  }
}

extension FallingViewModel {
  enum ReloadAction {
    case noticeButtonAction(NoticeViewCell.Action)
    case autoScroll
  }

  enum ScrollAction: Equatable {
    case scrollAfterDelete(FallingUser)
    case scroll(IndexPath)
    case pause

    static func == (lhs: Self, rhs: Self) -> Bool {
      switch(lhs, rhs) {
      case let (.scroll(lhsValue), .scroll(rhsValue)):
        return lhsValue == rhsValue
      case (.pause, .pause): return true
      case let (.scrollAfterDelete(lhsValue), .scrollAfterDelete(rhsValue)):
        return lhsValue == rhsValue
      default: return false
      }
    }
  }

  enum ScrollActionType {
    case scroll
    case pause
    case scrollAfterDelete(FallingUser)
  }
  typealias UserCardType = FallingUserCollectionViewCell.Action
  typealias NoticeCardType = NoticeViewCell.Action

  struct State: Equatable {
    var index: Int = 0
    var snapshot: [FallingDataModel] = []
    var topicIndex: String = ""

    var dailyUserCursorIndex = 0
    var isAlreadyTopicSelected = false

    var userInfo: FallingUserInfo = FallingUserInfo(selectDailyFallingIdx: 0, topicExpirationUnixTime: 0, isLast: false, userInfos: [])
    @Pulse var scrollAction: ScrollAction = .pause
    @Pulse var toast: String? = nil
    @Pulse var timeState: TimeState = .none
    @Pulse var shouldShowPause: Bool = false
    @Pulse var isLoading = false

    var indexPath: IndexPath {
      IndexPath(row: index, section: 0)
    }

    var user: FallingUser? {
      switch snapshot[safe: index] {
      case .fallingUser(let user): return user
      default: return nil
      }
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.index == rhs.index &&
      lhs.snapshot == rhs.snapshot &&
      lhs.scrollAction == rhs.scrollAction
    }
  }

  enum Mutation {
    case setScrollEvent(ScrollActionType)
    case updateIndexPath(Int)
    case removeSnapshot(FallingUser)

    case triggerFetchUser
    case applySnapshot
    case setRecentUserInfo(FallingUserInfo)
    case addFirstMetNoticeCard

    case addUser([FallingDataModel])
    case setIsLast(Bool)
    case setLoading(Bool)

    case selectAlert
    case toMatch(String, String)
    case toast(String)

    // MARK: Timer
    case stopTimer
    case startTimer
    case resetTimer
    case setTimeState(TimeState)

    // MARK: Cell
    case hidePause
    case showPause
  }
}

extension Array {
  @discardableResult
  mutating func remove(safeAt index: Index) -> Element? {
    guard self.count > index else { return nil }
    return remove(at: index)
  }

  subscript(safe index: Index) -> Element? {
    guard self.count > index else { return nil }
    return self[index]
  }
}
