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

final class FallingViewModel: ViewModelType {
  typealias CellType = FallingUserCollectionViewCell

  private let fallingUseCase: FallingUseCaseInterface

  weak var delegate: FallingActionDelegate?

  var disposeBag: DisposeBag = DisposeBag()

  private let timer = TFTimer(startTime: 15.0)

  private let alertActionSignal = PublishRelay<FallingAlertAction>()

  struct Input {
    let initialTrigger: Driver<Void>
    let viewDidAppear: Driver<Void>
    let viewWillDisappear: Driver<Void>
    let cellButtonAction: Driver<CellType.Action>
    let deleteAnimationComplete: Signal<Void>
  }

  struct Output {
    let state: Driver<State>
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

  private enum ScrollActionType {
    case scroll
    case pause
    case scrollAfterDelete(FallingUser)
  }

  struct State: Equatable {
    var index: Int = 0
    var snapshot: [FallingUser] = []
    var topicIndex: String = ""
    @Pulse var scrollAction: ScrollAction = .pause
    @Pulse var toast: String? = nil
    @Pulse var timeState: TimeState = .none
    @Pulse var shouldShowPause: Bool = false

    var indexPath: IndexPath {
      IndexPath(row: index, section: 0)
    }

    var user: FallingUser? {
      snapshot[safe: index]
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.index == rhs.index &&
      lhs.snapshot == rhs.snapshot &&
      lhs.scrollAction == rhs.scrollAction
    }
  }

  private enum Mutation {
    case setScrollEvent(ScrollActionType)
    case updateIndexPath(Int)
    case removeSnapshot(FallingUser)
    case fetchUser([FallingUser])

    case selectAlert
    case toChatRoom(String)
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

  init(fallingUseCase: FallingUseCaseInterface) {
    self.fallingUseCase = fallingUseCase
  }

  let initialState = State()
  var currentState: State {
    get { (try? state.value()) ?? initialState }
    set { state.onNext(newValue) }
  }
  lazy var state = BehaviorSubject<State>(value: initialState)
  var shareState: Observable<State> {
    state.share()
  }

  let scrollCommand = PublishRelay<ScrollAction>()

  func transform(input: Input) -> Output {
    let mutation = transform(action: input)
    let transfromMutation = transform(mutation: mutation)

    let state = transfromMutation
      .scan(initialState) { [weak self] state, mutation -> State in
        guard let self else { return state }
        return self.reduce(state: state, mutation: mutation)
      }
      .startWith(initialState)

    let transfromState = transform(state: state)
      .do(onNext: { [weak self] in self?.currentState = $0 })
      .asDriverOnErrorJustEmpty()

    transfromState
      .drive(self.state)
      .disposed(by: disposeBag)

    return Output(
      state: transfromState
    )
  }
}

extension FallingViewModel {
  private func transform(action input: Input) -> Observable<Mutation> {
    Observable.merge(
      input.viewWillDisappear
        .asObservable()
        .flatMap { _ -> Observable<Mutation> in
          return .concat(
            .just(.stopTimer),
            .just(.showPause)
          )
        },
      input.viewDidAppear
        .asObservable()
        .flatMap({ _ -> Observable<Mutation> in
          return .concat(

            .empty()
            )
        }),
      input.cellButtonAction
        .asObservable()
        .withLatestFrom(state) { ($0, $1) }
        .flatMap({ [weak self] action, state -> Observable<Mutation> in
          guard let self, let user = state.user else { return .empty() }
          switch action {
          case .likeTap:
            return self.fallingUseCase.like(userUUID: user.userUUID, topicIndex: state.topicIndex)
              .asObservable()
              .flatMap({ isMatched -> Observable<Mutation> in
                if isMatched {
                  return .concat(
                    .just(.toChatRoom("1111")),
                    .just(.stopTimer)
                  )
                }
                return .concat (
                  .just(.updateIndexPath(1))
                )
              })
              .catch { .concat(.just(.toast($0.localizedDescription)))}
          case .rejectTap:
            return self.fallingUseCase.reject(userUUID: user.userUUID, topicIndex: state.topicIndex)
              .asObservable()
              .flatMap { _ -> Observable<Mutation> in
                return .concat (
                  .just(.updateIndexPath(1))
                )
              }
              .catch { .concat(
                .just(.toast($0.localizedDescription))
              )}
          case .reportTap:
            return .concat(
              .just(.selectAlert),
              .just(.stopTimer)
            )
          case .pause(let shouldPause):
            return shouldPause ? .just(.stopTimer) : .just(.startTimer)
          }
        }),

      input.initialTrigger
        .asObservable()
        .flatMap { [unowned self] _ in
          self.fallingUseCase.user(alreadySeenUserUUIDList: [], userDailyFallingCourserIdx: 1, size: 100)
            .asObservable()
            .catchAndReturn(
              .init(
                selectDailyFallingIdx: 0,
                topicExpirationUnixTime: 0,
                isLast: false,
                userInfos: []
              )
            )
        }
        .flatMap { snapshot -> Observable<Mutation> in
          return .concat(
            .just(Mutation.fetchUser(snapshot.userInfos)),
            .just(.startTimer)
          )
        },

      input.deleteAnimationComplete
        .asObservable()
        .withLatestFrom(shareState.map(\.user))
        .compactMap { $0 }
        .flatMap { user -> Observable<Mutation> in
            .concat(.just(.removeSnapshot(user)),
                    .just(.setScrollEvent(.scroll))
            )
        }
    )
  }

  private func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {

    let signalMutation = self.alertActionSignal
      .withLatestFrom(state.compactMap(\.user)) { action, user in
        return (action, user)
      }
      .flatMap { [weak self] (action, user) -> Observable<Mutation> in
        guard let self else { return .empty() }
        switch action {
        case .cancel:
          return .just(.startTimer)
        case .block:
          return .concat(
            .just(.setScrollEvent(.scrollAfterDelete(user))),
            self.fallingUseCase.block(userUUID: user.userUUID)
              .asObservable()
              .map { "차단하기가 완료되었습니다. 해당 사용자와\n서로 차단되며 설정에서 확인 가능합니다." }
              .catch { .just($0.localizedDescription) }
              .map { Mutation.toast($0) },
            .just(.resetTimer)
          )
        case .report(let reason):
          return .concat(
            .just(.setScrollEvent(.scrollAfterDelete(user))),
            self.fallingUseCase.report(userUUID: user.userUUID, reason: reason)
              .asObservable()
              .map { "유저 신고 완료" }
              .catch { .just($0.localizedDescription) }
              .map { Mutation.toast($0) },
            .just(.resetTimer)
          )
        }
      }

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

    return Observable.merge(mutation, signalMutation, timeStateMutation, timeOut)
  }

  private func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .fetchUser(users):
      newState.snapshot = users
      return newState
    case let .updateIndexPath(offset):
      if newState.snapshot.count - 1 > newState.index {
        newState.index += offset
        newState.scrollAction = .scroll(newState.indexPath)
        timer.reset()
        return newState
      } else {
        timer.pause()
      }
      return newState
    case .selectAlert:
      self.delegate?.invoke(.toReportBlockAlert(listener: self))
      return newState
    case let .toChatRoom(chatRoomIndex):
      self.delegate?.invoke(.toChatRoom(chatRoomIndex: Int(chatRoomIndex) ?? 0))
      return newState
    case let .removeSnapshot(user):
      newState.snapshot.removeAll(where: { $0 == user })
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
    case .hidePause:
      newState.shouldShowPause = false
      return newState
    case .showPause:
      newState.shouldShowPause = true
      return newState
    }
  }

  public func transform(state: Observable<State>) -> Observable<State> {
    state
  }

  public func pulse<Result>(_ transformToPulse: @escaping (State) throws -> Pulse<Result>) -> Observable<Result> {
    state.map(transformToPulse).distinctUntilChanged(\.valueUpdatedCount).map(\.value)
  }
}

extension FallingViewModel: BlockOrReportAlertListener {
  enum FallingAlertAction: Equatable {
    case cancel
    case block
    case report(reason: String)
  }

  func didTapAction(_ action: BlockOrReportAction) {
    switch action {
    case .block:
      self.delegate?.invoke(.toBlockAlert(listener: self))
    case .report:
      self.delegate?.invoke(.toReportAlert(listener: self))
    case .cancel:
      self.alertActionSignal.accept(.cancel)
    }
  }
}

extension FallingViewModel: BlockAlertListener {
  func didTapAction(_ action: BlockAlertAction) {
    switch action {
    case .block:
      self.alertActionSignal.accept(.block)
    case .cancel:
      self.alertActionSignal.accept(.cancel)
    }
  }
}

extension FallingViewModel: ReportAlertListener {
  func didTapAction(_ action: ReportAlertAction) {
    switch action {
    case let .didTap(menu):
      self.alertActionSignal.accept(.report(reason: menu.key))
    case .cancel:
      self.alertActionSignal.accept(.cancel)
    }
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
