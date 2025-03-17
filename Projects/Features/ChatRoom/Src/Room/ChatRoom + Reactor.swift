//
//  ChatRoom + Reactor.swift
//  ChatRoom
//
//  Created by Kanghos on 2/10/25.
//

import Foundation
import ReactorKit
import Domain
import ChatRoomInterface

extension ChatRoomReactor {
  public enum Action {
    // MARK: Socket
    case send(String, ChatRoomInfo)
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
    case dismissWithMessage(String)

    // LifeCycle
    case didEnterBackground
    case willEnterForeground
  }

  public enum Mutation {
    case addMessage(ChatMessageType)
    case insertMessage([ChatMessageType])
    case setInfo(ChatRoomInfo)
    case changeBlurHidden(Bool)
    case showProfile(id: String, ProfileOutputHandler?)
    case showUserReportAlert(UserReportHandler?)
    case showExitAlert(ConfirmHandler?)
    case dismiss(String?)
    case subscribe
  }

  public struct State {
    var sections: [ChatViewSection]
    var info: ChatRoomInfo = .empty
    var roomTitle: String? = nil
    var isBlurHidden: Bool = true
    @Pulse var toast: String?
  }
}
