//
//  ChatRoomViewModel.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/14.
//

import Foundation

import Core
import ChatInterface
import Domain

import RxSwift
import RxCocoa
import ReactorKit

public typealias ConfirmHandler = ((ConfirmAction) -> Void)

public protocol ChatRoomOutputType {
  var onExit: ((ConfirmHandler?) -> Void)? { get set }
  var onReport: (((((UserReportAction) -> Void)?)) -> Void)? { get set }
  var onBack: (() -> Void)? { get set }
  var onProfile: ((String) -> Void)? { get set }
}

public enum ChatRoomAction {
  case onAppear
  case refresh
  case onBackBtnTap
  case onExit
  case onReport
  case onProfile(String)
}

public struct ChatViewSection {
  var items: [ChatViewSectionItem]
}

public enum ChatViewSectionItem {
  case incoming(BubbleReactor)
  case outgoing(BubbleReactor)
}

public final class ChatRoomReactor: ChatRoomOutputType, Reactor {
  public var initialState: State
  
  public enum Action {
    case viewDidLoad
    case send(String)
    case onAppear
    case refresh
    case onBackBtnTap
    case onExit
    case onReport
    case onProfile(String)
  }

  public enum Mutation {
    case addMessage(ChatMessage)
    case setInfo(ChatRoomInfo)
  }

  public struct State {
    var sections: [ChatViewSection]
    var info: ChatRoomInfo?
  }

  public var onExit: ((ConfirmHandler?) -> Void)?
  public var onReport: (((((UserReportAction) -> Void)?)) -> Void)?
  public var onBack: (() -> Void)?
  public var onProfile: ((String) -> Void)?

  private let chatUsecase: ChatUseCaseInterface
  private let userUseCase: UserDomainUseCaseInterface
  private let chatService: ChatService
  private let id: String

  private var disposeBag = DisposeBag()

  public init(
    chatUseCase: ChatUseCaseInterface,
    userUseCase: UserDomainUseCaseInterface,
    chatService: ChatService,
    id: String
  ) {
    self.chatUsecase = chatUseCase
    self.userUseCase = userUseCase
    self.id = id
    self.initialState = State(sections: [])
    self.chatService = chatService
    TFLogger.cycle(name: self)
  }
  deinit { TFLogger.cycle(name: self) }
}

extension ChatRoomReactor {
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return self.chatUsecase.room(id)
        .map { Mutation.setInfo($0) }
        .asObservable()
    case .onAppear: return .empty()
    case .refresh: return .empty()
    case .onExit: return .empty()
    case .onBackBtnTap: return .empty()
    case let .onProfile(id): return .empty()
    case let .send(message):
      chatService.sendMessage(message: .init(sender: "", senderUUID: "", imageURL: "", message: message))
      return .empty()
    case .onReport: return .empty()
    }
  }

  public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {

  }

  public func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .addMessage(message):
      state.
    case let .setInfo(info):
      state.info = info
    }
  }

//  public func transform(input: Input) -> Output {
//
//    let errorSubject = PublishSubject<Error>()
//    let isBlurHidden = PublishRelay<Bool>()
//    let userReportActionRelay = PublishRelay<UserReportType>()
//    let exitTrigger = PublishRelay<Void>()
//
//    let roomInfo = chatUsecase.room(id)
//      .asDriver { error in
//        errorSubject.onNext(error)
//        return .empty()
//      }
//
//    input.action
//      .flatMapLatest { [weak self] action -> Signal<Void> in
//        guard let owner = self else { return .empty() }
//        switch action {
//        case .onAppear: break
//        case .refresh: break
//        case .onBackBtnTap:
//          owner.onBack?()
//        case .onReport:
//          isBlurHidden.accept(false)
//          owner.onReport? {
//            isBlurHidden.accept(true)
//            switch $0 {
//            case .block:
//              userReportActionRelay.accept(.block(owner.id))
//            case let .report(reason):
//              userReportActionRelay.accept(.report(owner.id, reason))
//            case .cancel: break
//            }
//          }
//        case .onExit:
//          isBlurHidden.accept(false)
//          owner.onExit? { action in
//            isBlurHidden.accept(true)
//            switch action {
//            case .confirm:
//              exitTrigger.accept(Void())
//            case .cancel: break
//            }
//          }
//        case let .onProfile(id):
//          owner.onProfile?(id)
//        }
//        return .empty()
//      }
//      .emit(with: self) { owner, _ in
//
//      }.disposed(by: disposeBag)
//
//    userReportActionRelay
//      .withUnretained(self)
//      .flatMapLatest { owner, reportType in
//        owner.userUseCase.userReport(reportType)
//          .asObservable()
//          .catch { error in
//            errorSubject.onNext(error)
//            return .empty()
//          }
//      }
//      .subscribe(with: self) { owner, _ in
//        owner.onBack?()
//      }.disposed(by: disposeBag)
//
//    exitTrigger
//      .withUnretained(self)
//      .flatMapLatest({ owner, _ in
//        owner.chatUsecase.out(owner.id)
//          .asObservable()
//          .catch { error in
//            errorSubject.onNext(error)
//            return .empty()
//          }
//      })
//      .subscribe(with: self) { owner, _ in
//        owner.onBack?()
//      }.disposed(by: disposeBag)
//
//    return Output(
//      roomInfo: roomInfo
//    )
//  }
}
