//
//  FallingReactor.swift
//  Falling
//
//  Created by Kanghos on 2/8/25.
//

import Foundation
import ReactorKit

import Domain

extension FallingViewModel {

  enum Action {
    case viewDidLoad
    case viewWillDisappear
    case deleteAnimationComplete(FallingUser)

    case likeTap(FallingUser)
    case rejectTap(FallingUser)
    case pauseTap(Bool)
    case reportTap(FallingUser)

    case allMetTap
    case findTap
    case selectedFirstTap

    case userReportAlert(UserReportAction, FallingUser)

    case fetchUser(currentIndex: Int)
  }

  struct State: Equatable {
    var index: Int = 0
    var snapshot: [FallingDataModel] = []
    var topicIndex: String = ""

    var dailyUserCursorIndex = 0
    var isAlreadyTopicSelected = false

    var userInfo: FallingUserInfo = FallingUserInfo(selectDailyFallingIdx: 0, topicExpirationUnixTime: 0, isLast: false, userInfos: [])
    @Pulse var scrollAction: IndexPath? = nil // .pause
    @Pulse var toast: String? = nil
    @Pulse var timeState: TimeState = .none
    @Pulse var shouldShowPause: Bool = false
    @Pulse var isLoading = false
    @Pulse var deleteAnimationUser: FallingUser? = nil
    @Pulse var hideUserInfo: Bool = true

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

  enum Mutation {
//    case setScrollEvent(ScrollActionType)
    case showDeleteAnimation(FallingUser)
    case updateIndexPath(Int)
    case removeSnapshot(FallingUser)

    case triggerFetchUser
    case applySnapshot
    case setRecentUserInfo(FallingUserInfo)
    case addFirstMetNoticeCard

    case addUser([FallingDataModel])
    case setLoading(Bool)

    case selectAlert
    case toMatch(String, String)
    case toast(String)

    // MARK: Timer
    case stopTimer
    case startTimer
    case resetTimer
    case setTimeState(TimeState)

    // MARK: Cell
    case hidePause
    case showPause
    case setHideUserInfo(Bool)
  }
}

extension FallingUserInfo {
  var cards: [FallingDataModel] {
    userInfos.map(FallingDataModel.fallingUser(_:))
  }
}

extension NoticeViewCell.Action {
  func toFallingAction() -> FallingViewModel.Action {
    switch self {
    case .allMet:
      return .allMetTap
    case .find:
      return .findTap
    case .selectedFirst:
      return .selectedFirstTap
    }
  }
}
