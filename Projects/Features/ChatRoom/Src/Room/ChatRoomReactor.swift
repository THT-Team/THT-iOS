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
import ChatRoomInterface

public final class ChatRoomReactor: ChatRoomOutputType, Reactor {
  public var initialState: State

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
      talkUseCase.bind()
      talkUseCase.connect()
      return .concat([
        self.chatUsecase.room(id)
          .map(Mutation.setInfo),
        self.chatUsecase.history(roomIdx: id, chatIdx: nil, size: 10)
          .map(Mutation.insertMessage)
      ])
    case .willEnterForeground:
      talkUseCase.bind()
      talkUseCase.connect()
      return .empty()
    case .didEnterBackground:
      talkUseCase.disconnect()
      return .empty()
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
      talkUseCase.disconnect()
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
      talkUseCase.disconnect()
      return .concat([
        .just(.changeBlurHidden(true)),
        userUseCase.userReport(.report(self.id, reason))
          .asObservable()
          .map(Mutation.dismiss)])
    case .blockTap:
      talkUseCase.disconnect()
      return .concat([
        .just(.changeBlurHidden(true)),
        userUseCase.userReport(.block(self.id))
          .asObservable()
          .map(Mutation.dismiss)])
    case .onCancel:
      return .just(.changeBlurHidden(true))
    case .onBackBtnTap:
      talkUseCase.disconnect()
      return .just(.dismiss(nil))
    case let .onProfile(id):
      return .from([
        .changeBlurHidden(false),
        .showProfile(id: id) { [weak self] select in
          guard let self else { return }
          switch select {
          case .cancel:
            self.action.onNext(.onCancel)
          case .toast(let msg):
            self.action.onNext(.onCancel)
            self.action.onNext(.dismissWithMessage(msg))
          }
        }
      ])
    case let .dismissWithMessage(msg):
      talkUseCase.disconnect()
      return .just(.dismiss(msg))
    case .subscribe:
      talkUseCase.subscribe(topic: "/sub/chat/\(id)")
      return .empty()
    case let .send(message, info):
      talkUseCase.send(
        destination: "/pub/chat/\(id)",
        message: message, participant: info.participants)
      return .empty()
    }
  }

  public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let chatEvent = talkUseCase.listen()
      .debug("ChatReactor:")
      .compactMap { type -> Mutation? in
        switch type {
        case .message(let message):
          return Mutation.addMessage(message)
        case .stompConnected:
          return Mutation.subscribe
        case .stompDisconnected:
          return nil
        case .receipt(let id):
          print("receipt id: \(id)")
          return nil
        case .needAuth:
          return nil
        }
      }
    return Observable.merge(mutation, chatEvent)
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case .subscribe:
      action.onNext(.subscribe)
    case let .showExitAlert(handler):
      self.onExit?(handler)
    case let .showUserReportAlert(handler):
      self.onReport?(handler)
    case let .dismiss(toast):
      self.onBack?(toast)
    case let .showProfile(id, handler):
      self.onProfile?(ProfileItem(id: id, topic: state.info.talkSubject, issue: state.info.talkIssue), handler)
    case let .addMessage(message):
      state.sections[0].items.append(.create(from: message, actionSubject: self.action))
    case let .setInfo(info):
      state.info = info
    case let .changeBlurHidden(isHidden):
      state.isBlurHidden = isHidden
    case let .insertMessage(messages): 
      let items = messages.compactMap { [weak self] type -> ChatViewSectionItem? in
        guard let self else { return nil }
        return ChatViewSectionItem.create(from: type, actionSubject: self.action)
      }
      state.sections[0].items.insert(items)
    }
    return state
  }
}

extension ChatViewSectionItem {
  static func create(from type: ChatMessageType, actionSubject: ActionSubject<ChatRoomReactor.Action>) -> Self {
      let reactor = BubbleReactor(type)
      reactor.pulse(\.$showProfile)
        .compactMap { $0 }
        .map(ChatRoomReactor.Action.onProfile)
        .bind(to: actionSubject)
        .disposed(by: reactor.disposeBag)

      return ChatViewSectionItem.transfrom(from: type, reactor: reactor)
  }
}
