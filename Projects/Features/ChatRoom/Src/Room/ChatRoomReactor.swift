//
//  ChatRoomViewModel.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/14.
//

import Foundation

import Core
import Domain

import RxSwift
import RxCocoa
import ReactorKit

public protocol ChatRoomOutputType {
  var onExit: ((ConfirmHandler?) -> Void)? { get set }
  var onReport: ((UserReportHandler?) -> Void)? { get set }
  var onBack: ((String?) -> Void)? { get set }
  var onProfile: ((ProfileItem, ProfileOutputHandler?) -> Void)? { get set }
}

public final class ChatRoomReactor: ChatRoomOutputType, Reactor {
  public var initialState: State

  public enum Action {
    // MARK: Socket
    case send(String)
    case subscribe

    case viewDidLoad
    case paging

    case onBackBtnTap

    case onExitBtnTap
    case onExit

    case onReportBtnTap
    case blockTap
    case reportTap(String)
    case onProfile(String)
    case onCancel // Sheet에서 Cancel 누른 액션
    case showToast(String)
  }

  public enum Mutation {
    case addMessage(ChatMessage)
    case addHistory([ChatMessage])
    case setInfo(ChatRoomInfo)
    case changeBlurHidden(Bool)
    case showProfile(ProfileItem, ProfileOutputHandler?)
    case showUserReportAlert(UserReportHandler?)
    case showExitAlert(ConfirmHandler?)
    case setToast(String)
    case dismiss(String?)
  }

  public struct State {
    var sections: [ChatViewSection]
    var info: ChatRoomInfo?
    var isBlurHidden: Bool = true
    @ReactorKit.Pulse var toast: String?
  }

  // MARK: Cooridnator

  public var onExit: ((ConfirmHandler?) -> Void)?
  public var onReport: ((UserReportHandler?) -> Void)?
  public var onBack: ((String?) -> Void)?
  public var onProfile: ((ProfileItem, ProfileOutputHandler?) -> Void)?

  // MARK: Domain
  private let chatUsecase: ChatUseCaseInterface
  private let userUseCase: UserDomainUseCaseInterface
  private let talkUseCase: TalkUseCaseInterface
  private let id: String

  private var disposeBag = DisposeBag()

  public init(
    chatUseCase: ChatUseCaseInterface,
    userUseCase: UserDomainUseCaseInterface,
    talkUseCase: TalkUseCaseInterface,
    id: String
  ) {
    self.talkUseCase = talkUseCase
    self.userUseCase = userUseCase
    self.chatUsecase = chatUseCase
    self.id = id
    self.initialState = State(sections: [.init(items: [])])
    TFLogger.cycle(name: self)
  }
  deinit { TFLogger.cycle(name: self) }
}

extension ChatRoomReactor {
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return .concat([
        self.chatUsecase.room(id)
          .map(Mutation.setInfo),
        self.chatUsecase.history(roomIdx: id, chatIdx: nil, size: 10)
          .map(Mutation.addHistory)
      ])
    case .paging: return .empty()
    case .onExitBtnTap:
      return .from([
        .changeBlurHidden(false),
        .showExitAlert { [weak self] select in
          switch select {
          case .confirm: self?.action.onNext(.onExit)
          case .cancel: self?.action.onNext(.onCancel)
          }
        }
      ])
    case .onExit:
      return .concat([
        .just(.changeBlurHidden(true)),
        chatUsecase.out(id)
          .asObservable()
          .flatMap { _ -> Observable<Mutation> in return .empty() },
        .just(.dismiss(nil))
      ])
    case .onReportBtnTap:
      return .from([
        .changeBlurHidden(false),
        .showUserReportAlert { [weak self] select in
          switch select {
          case .block: self?.action.onNext(.blockTap)
          case let .report(reason): self?.action.onNext(.reportTap(reason))
          case .cancel: self?.action.onNext(.onCancel)
          }
        }
      ])
    case let .reportTap(reason):
      return .concat([
        .just(.changeBlurHidden(true)),
        userUseCase.userReport(.report(self.id, reason))
          .asObservable()
          .map(Mutation.setToast)])
    case .blockTap:
      return .concat([
        .just(.changeBlurHidden(true)),
        userUseCase.userReport(.block(self.id))
          .asObservable()
          .map(Mutation.setToast)])
    case .onCancel:
      return .just(.changeBlurHidden(true))
    case .onBackBtnTap:
      self.onBack?(nil)
      return .empty()
    case let .onProfile(id):
      guard let info = self.currentState.info else {
        return .empty()
      }
      let item = ProfileItem(id: id, topic: info.talkSubject, issue: info.talkIssue)
      return .from([
        .changeBlurHidden(false),
        .showProfile(item) { [weak self] select in
          guard let self else { return }
          switch select {
          case .cancel:
            self.action.onNext(.onCancel)
          case .toast(let msg):
            self.action.onNext(.onCancel)
            self.action.onNext(.showToast(msg))
          }
        }
      ])
    case .subscribe:
      talkUseCase.subscribe(topic: "/sub/chat/\(id)")
      return .empty()
    case let .send(message):
      guard let participants = self.currentState.info?.participants else {
        return .empty()
      }
      talkUseCase.send(
        destination: "/pub/chat/\(id)",
        message: .init(participant: participants[0], message: message)
      )
      return .empty()
    case let .showToast(message):
      return .just(.setToast(message))
    }
  }

  public func transform(action: Observable<Action>) -> Observable<Action> {
    let chatAction = talkUseCase.listen()
      .filter { $0 == .some(.stompConnected) }
      .map { _ in Action.subscribe }
    return Observable.merge(action, chatAction)
  }

  public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let chatEvent = talkUseCase.listen()
      .compactMap { type -> Mutation? in
        guard case let .message(msg) = type else { return nil }
        return Mutation.addMessage(msg)
      }
    return Observable.merge(mutation, chatEvent)
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .showExitAlert(handler):
      self.onExit?(handler)
    case let .showUserReportAlert(handler):
      self.onReport?(handler)
    case let .dismiss(toast):
      self.onBack?(toast)
    case let .showProfile(item, handler):
      self.onProfile?(item, handler)
    case let .addMessage(message):
      let reactor = BubbleReactor(message)
      reactor.pulse(\.$showProfile)
        .compactMap { $0 }
        .map(Action.onProfile)
        .bind(to: self.action)
        .disposed(by: reactor.disposeBag)

      state.sections[0].items.appendMessage(.incoming(reactor))
    case let .setInfo(info):
      state.info = info
    case let .changeBlurHidden(isHidden):
      state.isBlurHidden = isHidden
    case let .addHistory(messages): break
      // SectionModel key: values
      // Message -> Reactor
      // Reactor --> ViewMessages

//      let reactors = messages.map(BubbleReactor.init)
//        .compactMap { [weak self] reactor -> BubbleReactor? in
//          guard let self else { return nil }
//          reactor.pulse(\.$showProfile)
//            .compactMap { $0 }
//            .map(Action.onProfile)
//            .bind(to: self.action)
//            .disposed(by: reactor.disposeBag)
//          return reactor
//        }
//
//      state.sections[0].items.appendMessages()
    case let .setToast(msg):
      self.onBack?(msg)
    }
    return state
  }

  private func makeBubbleReactor(from message: ChatMessage) -> BubbleReactor {
    let reactor = BubbleReactor(message)
    reactor.pulse(\.$showProfile)
      .compactMap { $0 }
      .map(Action.onProfile)
      .bind(to: self.action)
      .disposed(by: disposeBag)

    return reactor
  }
}

extension Array where Element == ChatViewSectionItem {
  mutating func appendMessage(_ item: Element) {
    var mutable = self
    mutable.append(item)
    self = mutable
  }

  mutating func appendMessages(_ items: [Element]) {
    var mutable = self
    mutable.append(contentsOf: items)
    self = mutable
  }
}
