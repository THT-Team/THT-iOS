//
//  MessageReactor.swift
//  ChatRoom
//
//  Created by Kanghos on 1/18/25.
//

import Foundation
import ReactorKit
import Domain

public final class BubbleReactor: Reactor {

  public var disposeBag = DisposeBag()
  
  public enum Action {
    case profileTap
    case change(BubbleState)
  }

  public enum Mutation {
    case showProfile
    case setBuuble(BubbleState)
  }

  public struct State {
    public var messageModel: ChatMessageItem
    public var message: String {
      messageModel.message.msg
    }
    public var dateText: String {
      messageModel.message.dateTime.toTimeString()
    }
    public var sender: String {
      messageModel.message.sender
    }
    public var senderUUID: String {
      messageModel.message.senderUuid
    }
    public var imageURL: String {
      messageModel.message.imgUrl
    }
    public var index: String {
      messageModel.message.chatIdx
    }
    public var bubble: BubbleState
    
    @Pulse var showProfile: String?
  }

  public let initialState: State

  public init(_ message: ChatMessageItem, bubble: BubbleState) {
    self.initialState = State(messageModel: message, bubble: bubble, showProfile: nil)
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .profileTap:
      return .just(.showProfile)
    case let .change(bubble):
      return .just(.setBuuble(bubble))
    }
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .showProfile:
      newState.showProfile = state.senderUUID
    case .setBuuble(let bubble):
      newState.bubble = bubble
    }
    return newState
  }
}

extension BubbleReactor.State: Equatable {
  public static func == (lhs: BubbleReactor.State, rhs: BubbleReactor.State) -> Bool {
    lhs.index == rhs.index
  }
}

extension BubbleReactor: Hashable, Equatable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(initialState.index)
  }

  public static func == (lhs: BubbleReactor, rhs: BubbleReactor) -> Bool {
    lhs.currentState.index == rhs.currentState.index
  }
}
