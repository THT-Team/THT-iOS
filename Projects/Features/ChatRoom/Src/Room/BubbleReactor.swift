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
  }

  public enum Mutation {
    case showProfile
  }

  public struct State {
    var message: String?
    var dateText: String
    var sender: String
    var senderUUID: String
    var imageURL: String
    var index: String
    var isLinked: Bool
    @Pulse var showProfile: String?
  }

  public let initialState: State

  public init(_ message: ChatMessageType, shouldShowDate: Bool) {
    let message = message.message
    self.initialState = State(
      message: message.msg,
      dateText: message.dateTime.toTimeString(),
      sender: message.sender,
      senderUUID: message.senderUuid,
      imageURL: message.imgUrl,
      index: message.chatIdx,
      isLinked: shouldShowDate,
      showProfile: nil
    )
  }


  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .profileTap:
      return .just(.showProfile)
    }
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .showProfile:
      newState.showProfile = state.senderUUID
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
