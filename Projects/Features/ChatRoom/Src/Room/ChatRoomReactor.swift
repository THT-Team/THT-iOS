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
      self.appendNewMessage(to: &state.sections, newMessage: message)
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
  static func create(from type: ChatMessageItem, bubble: BubbleState, actionSubject: ActionSubject<ChatRoomReactor.Action>) -> Self {
    let reactor = BubbleReactor(type, bubble: bubble)
    
    reactor.pulse(\.$showProfile)
      .compactMap { $0 }
      .map(ChatRoomReactor.Action.onProfile)
      .bind(to: actionSubject)
      .disposed(by: reactor.disposeBag)
    
    return ChatViewSectionItem(message: type, reactor: reactor)
  }
}

extension ChatRoomReactor {
  struct CellViewModel {
    var isLinked: Bool
    let message: ChatMessageItem
  }
  
  private func addHistory(to section: inout [ChatViewSection], items: [Date: [ChatMessageItem]], action: ActionSubject<ChatRoomReactor.Action>) {
    
    var calender = Calendar.current
    calender.locale = Locale(identifier: "ko-kr")
    let result = items
      .sorted { $0.key < $1.key }
      .map { date, messagesList in
        var mutable = [(item: ChatMessageItem, state: BubbleState)]()
        for (index, current) in messagesList.enumerated() {
          mutable.append((current, BubbleState.single))
          
          if index > 0 {
            let prev = mutable[index - 1].item
            
            let sameSender = prev.senderType == current.senderType
            let sameTime = calender.isDate(prev.message.dateTime, equalTo: current.message.dateTime, toGranularity: .minute)
            
            let needUpdateBubble = sameSender && sameTime
            
            if needUpdateBubble {
              if mutable[index - 1].state == .tail {
                mutable[index - 1].state = .middle
              } else {
                mutable[index - 1].state = .head
              }
              
              mutable[index].state = .tail
            }
          }
        }
        return (date, mutable.map { (item, state) in
          ChatViewSectionItem.create(from: item, bubble: state, actionSubject: action)
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
    newMessage: ChatMessageItem
  ) {
    
    // 섹션이 존재하는 경우
    if let lastIndex = sections.lastIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: newMessage.message.dateTime) }) {
      var mutable = sections[lastIndex]
      
      var calender = Calendar.current
      calender.locale = Locale(identifier: "ko-kr")
      
      if let prev = mutable.items.last {
        
        let sameSender = prev.message.senderType == newMessage.senderType
        let sameMinute = calender.isDate(prev.message.message.dateTime, equalTo: newMessage.message.dateTime, toGranularity: .minute)
        
        let needUpdateBubble = sameSender && sameMinute
        if needUpdateBubble {
          if mutable.items[mutable.items.count - 1].reactor.currentState.bubble == .tail {
            mutable.items[mutable.items.count - 1].reactor.action.onNext(.change(.middle))
          } else {
            mutable.items[mutable.items.count - 1].reactor.action.onNext(.change(.head))
          }
          mutable.items.appendItem(ChatViewSectionItem.create(from: newMessage, bubble: .tail, actionSubject: self.action))
        } else {
          mutable.items.appendItem(ChatViewSectionItem.create(from: newMessage, bubble: .single, actionSubject: self.action))
        }
      } else {
        mutable.items.appendItem(ChatViewSectionItem.create(from: newMessage, bubble: .single, actionSubject: self.action))
      }
      
      sections[lastIndex] = mutable
    } else {
      // 새로운 날짜 섹션 생성
      let newSection = ChatViewSection(
        date: newMessage.message.dateTime,
        items: [
          ChatViewSectionItem.create(from: newMessage, bubble: .single, actionSubject: self.action)
        ])
      
      sections.append(newSection)
    }
  }
}
//
//  private func addMessage(to sections: inout [ChatViewSection], type message: ChatMessageItem) {
//    
//    if var lastSection = sections.last, Calendar.current.isDate(lastSection.date, inSameDayAs: message.message.dateTime),
//       var prev = lastSection.items.last
//    {
//      let isLinked: Bool = {
//        let prevIsIncoming = prev.message.senderType
//        let newIsIncomfing = message.senderType
//        
//        let sameSender = newIsIncomfing == prevIsIncoming
//        let prevDate = lastSection.date
//        let currentDate = message.message.dateTime
//        
//        var calender  = Calendar.current
//        calender.locale = Locale(identifier: "ko-kr")
//        
//        let sameMinute = Calendar.current.compare(prevDate, to: currentDate, toGranularity: .minute) == .orderedSame
//        
//        return !(sameSender && sameMinute)
//      }()
//      prev.isLinked = isLinked
//      prev.reactor.action
//      
//      var currentSetion = lastSection.items
//      currentSetion[currentSetion.count - 1] = prev
//      currentSetion.append(ChatViewSectionItem.create(from: message, shouldShowDate: false, actionSubject: self.action))
//      
//      lastSection.items = currentSetion
//      sections[sections.count - 1] = lastSection
//    } else {
//      sections.append(ChatViewSection(date: message.message.dateTime, items: [ChatViewSectionItem.create(from: message, shouldShowDate: true, actionSubject: self.action)]))
//    }
//  }
//}
