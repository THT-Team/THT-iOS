//
//  FallingReactor.swift
//  Falling
//
//  Created by Kanghos on 2/8/25.
//

import Foundation
import ReactorKit
import UIKit

import DSKit
import Domain

extension FallingViewModel {
  
  enum Action {
    // MARK: LifeCycle
    case viewDidLoad
    case viewWillDisappear
    case navigationLeftBarButtonItemTap
    
    // MARK: Custom Scroll Animation
    case deleteAnimationComplete(FallingUser)
    
    // MARK: User Card Actions
    case likeTap(FallingUser)
    case rejectTap(FallingUser)
    case pauseTap(Bool)
    case reportTap(FallingUser)
    
    // MARK: NoticeView Actions
    case allMetTap
    case findTap
    case selectedFirstTap
    case dummyUserStartTap
    
    // MARK: ReportAlert Actions
    case userReportAlert(UserReportAction, FallingUser)
    
    // MARK: TopicView Action
    case tapTopicStart(DailyKeyword)
    
    // MARK: Fetch Action
    case fetchDailyTopics
    case fetchUserFirst(NoticeViewCell.Action)
    case fetchNextUsers
    
    // MARK: LoadingView Action
    case loadingCloseButtonTap
    
    // MARK: MacthView Action
    case matchCloseButtonTap
  }
  
  struct State: Equatable {
    var index: Int = 0
    var snapshot: [FallingDataModel] = []
    
    var dailyUserCursorIndex = 0
    
    var userInfo: FallingUserInfo?
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
    
    var topicExpirationUnixTime: Date?
    
    var topicIndex: Int {
      userInfo?.selectDailyFallingIndex ?? -1
    }
    
    var currentAction: NoticeViewCell.Action = .selectedFirst
    
    var dummyUserImage: UIImage {
      [
        DSKitAsset.Image.DummyUser.userCardWithBlur1.image,
        DSKitAsset.Image.DummyUser.userCardWithBlur2.image,
        DSKitAsset.Image.DummyUser.userCardWithBlur3.image,
        DSKitAsset.Image.DummyUser.userCardWithBlur4.image,
        DSKitAsset.Image.DummyUser.userCardWithBlur5.image,
        DSKitAsset.Image.DummyUser.userCardWithBlur6.image,
        DSKitAsset.Image.DummyUser.userCardWithBlur7.image,
        DSKitAsset.Image.DummyUser.userCardWithBlur8.image,
        DSKitAsset.Image.DummyUser.userCardWithBlur9.image,
        DSKitAsset.Image.DummyUser.userCardWithBlur10.image
      ].randomElement() ?? .init()
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
    case incrementIndex
    case removeSnapshot(by: FallingUser)
    
    // MARK: User
    case applySnapshot
    case setDailyUserCursorIndex(FallingUserInfo)
    case setRecentUserInfo(FallingUserInfo)
    case setCurrentAction(NoticeViewCell.Action)
    
    // MARK: Topic
    case addTopicOrNotice(FallingDataModel)
    case setHasChosenDailyTopic(Bool)
    case setTopicExpirationUnixTime(Date)
    
    // MARK: Condinator
    case selectAlert
    case toMatch(String, String, String)
    case toTopicBottomSheet(Date)
    
    case toast(String)
    
    // MARK: Timer
    case stopTimer
    case startTimer
    case restartTimer
    case setTimeState(TimeState)
    
    // MARK: Cell
    case hidePause
    case showPause
    case setHideUserInfo(Bool)
    
    case setLoading(Bool)
    
    case empty
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
