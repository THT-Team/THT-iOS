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
    case dummyUserStartTap
    
    case userReportAlert(UserReportAction, FallingUser)
    
    case tapTopicStart(DailyKeyword)
    case fetchDailyTopics
    case fetchUserFirst(NoticeViewCell.Action)
    case fetchNextUsers(NoticeViewCell.Action)
    case closeButtonTap
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
    
    var topicIndex: Int {
      userInfo?.selectDailyFallingIndex ?? -1
    }
    
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
    case removeSnapshot(FallingUser)
    
    // MARK: User
    case applySnapshot
    case setDailyUserCursorIndex(FallingUserInfo)
    case setRecentUserInfo(FallingUserInfo)
    case addTopicOrNotice(FallingDataModel)
    case setHasChosenDailyTopic(Bool)
    
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
