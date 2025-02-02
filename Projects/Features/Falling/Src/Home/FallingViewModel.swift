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
  
  private var userDailyFallingCourserIdx = 0
  private let infiniteScrollAction = PublishRelay<Void>()
  private let recentUserInfo = BehaviorRelay<FallingUserInfo?>(value: nil)
  private var alreadySelectedTopic = false
  
  private let timer = TFTimer(startTime: 15.0)
  private let alertActionSignal = PublishRelay<FallingAlertAction>()
  
  struct Input {
    let viewDidLoad: Driver<ReloadAction>
    let viewWillDisappear: Driver<Void>
    let cellButtonAction: Driver<CellType.Action>
    let deleteAnimationComplete: Signal<Void>
    let noticeButtonAction: Driver<ReloadAction>
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
    var snapshot: [FallingViewController.FallingDataModel] = []
    var topicIndex: String = ""
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
  
  private enum Mutation {
    case setScrollEvent(ScrollActionType)
    case updateIndexPath(Int)
    case removeSnapshot(FallingUser)
    
    case fetchUser(ReloadAction)
    case setRecentUserInfo(FallingUserInfo?)
    case setUser([FallingViewController.FallingDataModel])
    case addUser([FallingViewController.FallingDataModel])
    case setIsLast(Bool)
    case setLoading(Bool)
    
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
      
      
      Driver.merge(input.viewDidLoad, input.noticeButtonAction)
        .asObservable()
        .map(Mutation.fetchUser),
      
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
    let fetchUser = mutation
      .flatMap { [weak self] mutation -> Observable<Mutation> in
        guard let self = self else { return .empty() }
      switch mutation {
      case .fetchUser(let reloadAction):
        switch reloadAction {
        case .noticeButtonAction(let buttonAction):
          switch buttonAction {
          case .selectedFirst:
            self.alreadySelectedTopic = true
            self.userDailyFallingCourserIdx = 0
          case .allMet:
            self.userDailyFallingCourserIdx += 20
          case .find:
            if let recentUserInfo = self.recentUserInfo.value {
              return .concat(
                .just(.setUser(recentUserInfo.userInfos.map { FallingViewController.FallingDataModel.fallingUser($0) })),
                .just(.startTimer)
              )
            } else {
              return Observable.empty()
            }
          }
          
        case .autoScroll:
          self.userDailyFallingCourserIdx += 20
        case .viewDidLoad:
          if !self.alreadySelectedTopic {
            return .just(.setUser([.notice(.selectedFirst)]))
          } else { break }
        }
        
        return .concat(
          .just(.setLoading(true)),
          self.fallingUseCase.user(
            alreadySeenUserUUIDList: [],
            userDailyFallingCourserIdx: self.userDailyFallingCourserIdx,
            size: 20
          )
          .retry(when: { errorObservable in
            errorObservable
              .enumerated()
              .flatMap { attempt, error in
                switch reloadAction {
                case .noticeButtonAction:
                  if attempt < 2 { return Observable<Int>.just(attempt).delay(.seconds(3), scheduler: MainScheduler.instance)
                  } else {
                    return Observable.error(error)
                  }
                default: return Observable.empty()
                }
              }
          })
          .asObservable()
          .flatMap { userInfo -> Observable<Mutation> in
            switch reloadAction {
            case .noticeButtonAction(let buttonAction):
              switch buttonAction {
              case .selectedFirst, .allMet:
                if !userInfo.userInfos.isEmpty {
                  return .concat(
                    .just(.setRecentUserInfo(userInfo)),
                    .just(.setUser([.notice(.find)]))
                  )
                } else {
                  return .just(.setRecentUserInfo(userInfo))
                }
              default: return Observable.empty()
              }
              
            case .autoScroll:
              return .concat(
                .just(.setRecentUserInfo(userInfo)),
                .just(.addUser(userInfo.userInfos.map { FallingViewController.FallingDataModel.fallingUser($0)})),
                .just(.startTimer)
              )
            default:
              return .concat(
                .just(.setRecentUserInfo(userInfo)),
                .just(.setUser(userInfo.userInfos.map { FallingViewController.FallingDataModel.fallingUser($0)})),
                .just(.startTimer)
              )
            }
          },
          .just(.setLoading(false))
        )
      default: return .empty()
      }
    }
    
    let infiniteScrollAction = self.infiniteScrollAction
      .withLatestFrom(self.recentUserInfo) { [weak self] _, recentUserInfo ->
        Observable<Mutation> in
        guard let self = self else { return .empty() }
        if recentUserInfo?.isLast ?? false {
          return .empty()
        }
        
        self.userDailyFallingCourserIdx += 20
        return .just(.fetchUser(.autoScroll))
      }
      .flatMap { $0 }
    
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
    
    return Observable.merge(fetchUser, infiniteScrollAction, mutation, signalMutation, timeStateMutation, timeOut)
  }
  
  private func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setUser(let userInfos):
      newState.snapshot = userInfos
      if self.recentUserInfo.value?.isLast ?? false {
        newState.snapshot.append(.notice(.allMet))
      }
      return newState
      
    case let .addUser(userInfos):
      newState.snapshot += userInfos
      timer.start()
      return newState
      
    case let .setRecentUserInfo(userInfo):
      self.recentUserInfo.accept(userInfo)
      return newState
      
    case let .updateIndexPath(offset):
      if newState.snapshot.count - 1 > newState.index {
        newState.index += offset
        newState.scrollAction = .scroll(newState.indexPath)
        timer.reset()
        
        if newState.index % newState.snapshot.count == newState.snapshot.count - 1 {
          self.infiniteScrollAction.accept(())
        }
        
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
  
  public func transform(state: Observable<State>) -> Observable<State> {
    state
  }
  
  public func pulse<Result>(_ transformToPulse: @escaping (State) throws -> Pulse<Result>) -> Observable<Result> {
    state.map(transformToPulse).distinctUntilChanged(\.valueUpdatedCount).map(\.value)
  }
}

extension FallingViewModel {
  enum ReloadAction {
    case viewDidLoad
    case noticeButtonAction(NoticeViewCell.Action)
    case autoScroll
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
