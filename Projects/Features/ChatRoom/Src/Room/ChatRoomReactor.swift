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
    self.initialState = State(sections: [])
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
        case .connected:
          return Mutation.subscribe
        case .disconnected:
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
      self.addMessage(to: &state.sections, type: message)
    case let .setInfo(info):
      state.info = info
    case let .changeBlurHidden(isHidden):
      state.isBlurHidden = isHidden
      
    // history
    case let .insertMessage(messageGroup):
      addHistory(to: &state.sections, items: messageGroup, action: self.action)
    }
    return state
  }
}

extension ChatViewSectionItem {
  static func create(from type: ChatMessageType, shouldShowDate: Bool,  actionSubject: ActionSubject<ChatRoomReactor.Action>) -> Self {
      let reactor = BubbleReactor(type, shouldShowDate: shouldShowDate)
      reactor.pulse(\.$showProfile)
        .compactMap { $0 }
        .map(ChatRoomReactor.Action.onProfile)
        .bind(to: actionSubject)
        .disposed(by: reactor.disposeBag)
    
    switch type {
    case .incoming: return ChatViewSectionItem.incoming(reactor)
    case .outgoing: return ChatViewSectionItem.outgoing(reactor)
    }
  }
}

extension ChatRoomReactor {
  struct CellViewModel {
    var isLinked: Bool
    let message: ChatMessageType
  }
  
  private func addHistory(to section: inout [ChatViewSection], items: [Date: [ChatMessageType]], action: ActionSubject<ChatRoomReactor.Action>) {
    
    var result = items
      .sorted { $0.key < $1.key }
      .map { date, messagesList in
        var mutable = [CellViewModel]()
        for (index, messaeg) in messagesList.enumerated() {
          var tuple = CellViewModel(isLinked: false, message: messaeg)
          mutable.append(tuple)
          
          if index > 0 {
            let prev = messagesList[index - 1]
            if ChatMessageType.isLinked(lhs: prev, rhs: messaeg) {
              mutable[index - 1].isLinked = true
            }
          }
        }
        return (date, mutable.map { dto in
          ChatViewSectionItem.create(from: dto.message, shouldShowDate: dto.isLinked, actionSubject: action)
        })
      }
      .map { date, dtos in
      let items = dtos
      return ChatViewSection(date: date, items: items)
    }
    
    section.append(contentsOf: result)
  }
  
  func appendNewMessage(
    to sections: inout [ChatViewSection],
    newMessage: ChatMessageType
  ) {
    
    // 섹션이 존재하는 경우
    if let lastIndex = sections.lastIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: newMessage.message.dateTime) }) {
      var lastSection = sections[lastIndex]
      
      var vm = CellViewModel(isLinked: false, message: newMessage)
      
      if let prev = lastSection.items.last {
        let sameSender = prev.sendType == newMessage.senderType
        
        let sameMinute = newMessage.message.dateTime.toTimeString() == prev.date
        if sameSender && sameMinute {
          var updatedPrev = prev
//          updatedPrev
        }
      }
      
      lastSection.items.appendItem(ChatViewSectionItem.create(from: newMessage, shouldShowDate: true, actionSubject: self.action))
      sections[lastIndex] = lastSection
    } else {
      // 새로운 날짜 섹션 생성
      let newVM = CellViewModel(isLinked: false, message: newMessage)
      let newSection = ChatViewSection(date: newMessage.message.dateTime, items: [ChatViewSectionItem.create(from: newMessage, shouldShowDate: newVM.isLinked, actionSubject: self.action)])
      
      sections.append(newSection)
    }
  }
  
  private func addMessage(to sections: inout [ChatViewSection], type message: ChatMessageType) {
    
    if var lastSection = sections.last, Calendar.current.isDate(lastSection.date, inSameDayAs: message.message.dateTime),
       let prev = lastSection.items.last
    {
      let shouldShow: Bool = {
        let prevIsIncoming = prev.sendType
        let newIsIncomfing = message.senderType
        
        let sameSender = newIsIncomfing == prevIsIncoming
        let prevDate = lastSection.date
        let currentDate = message.message.dateTime
        let sameDay = Calendar.current.isDate(prevDate, inSameDayAs: currentDate)
        
        let sameMinute = Calendar.current.compare(prevDate, to: currentDate, toGranularity: .minute) == .orderedSame
        
        return !(sameSender && sameDay && sameMinute)
      }()
      
      lastSection.items.appendItem(ChatViewSectionItem.create(from: message, shouldShowDate: shouldShow, actionSubject: self.action))
      sections[sections.count - 1] = lastSection
    } else {
      sections.append(ChatViewSection(date: message.message.dateTime, items: [ChatViewSectionItem.create(from: message, shouldShowDate: true, actionSubject: self.action)]))
    }
  }
}
