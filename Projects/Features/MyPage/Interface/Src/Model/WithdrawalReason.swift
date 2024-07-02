//
//  WithdrawalReason.swift
//  MyPageInterface
//
//  Created by Kanghos on 7/4/24.
//

import Foundation

public enum WithdrawalReason {
  case stop
  case matched
  case disLikeApp
  case newStart
  case problem
  case other
}

public extension WithdrawalReason {
  var emoji: String {
    switch self {
    case .stop: "📌"
    case .matched: "❤️"
    case .disLikeApp: "🥲"
    case .newStart: "✅"
    case .problem: "🔧"
    case .other: "✏️"
    }
  }

  var label: String {
    switch self {
    case .stop: "당분간 폴링 사용을\n중단하려고 함"
    case .matched: "애인이 생겼음"
    case .disLikeApp: "폴링이 마음에\n들지 않음"
    case .newStart: "새롭게 다시\n시작하고 싶음"
    case .problem: "문제가 발생함"
    case .other: "기타"
    }
  }
}

public struct WithdrawalReasonDetailProvider {
  static let defaulDescription: String = "계정을 삭제하면 프로필, 메세지, 사진, 매칭 회원이 함께\n삭제되며, 삭제 후에는 다시 되돌릴 수 없습니다.\n\n계정을 정말 탈퇴하시겠어요?"
  static let feedBackDescription: String = "피드백을 보내 주시면 앞으로 서비스 개선에\n반영하겠습니다. 폴링을 탈퇴하시는 이유는\n무엇인가요?"
  public static func createReasonDetail(_ reason: WithdrawalReason) -> WithdrawalReasonDetail {
    switch reason {
    case .stop: WithdrawalReasonDetail(
      title: "계정 탈퇴하시겠어요?",
      description: Self.defaulDescription,
      reasonArray: [])
    case .matched: WithdrawalReasonDetail(
      title: "축하합니다! 🤍",
      description: Self.defaulDescription,
      reasonArray: [])
    case .disLikeApp: WithdrawalReasonDetail(
      title: "피드백 보내기",
      description: Self.feedBackDescription,
      reasonArray: [
        .noPersonToTalk, .hardToMatch, .hardToUse, .tooOftenCrash, .payToWin
      ])
    case .newStart: WithdrawalReasonDetail(
      title: "피드백 보내기",
      description: Self.feedBackDescription,
      reasonArray: [
        .failToSyncProfile, .hardToMatch, .rematch, .noPersonToTalk
      ])
    case .problem: WithdrawalReasonDetail(
      title: "피드백 보내기",
      description: Self.feedBackDescription,
      reasonArray: [
        .lookSamePerson, .hardToMatch, .disappearMatchedPerson, .tooOftenCrash
      ])
    case .other: WithdrawalReasonDetail(
      title: "피드백 보내기",
      description: Self.feedBackDescription,
      reasonArray: [])
    }
  }
}

public struct WithdrawalReasonDetail {
  public let title, description: String
  public let reasonArray: [Reason]
}

public extension WithdrawalReasonDetail {

  enum Reason: String {
    case tooOftenCrash = "앱이 너무 자주 다운 됨"
    case hardToUse = "앱을 사용하기 어려움"
    case hardToMatch = "매칭이 잘 안됨"
    case lookSamePerson = "똑같은 사람들이 자주 보임"
    case disappearMatchedPerson = "매칭된 회원들이 사라짐"
    case failToSyncProfile = "프로필 정보가 연동되지 않음"
    case rematch = "내 매칭 회원을 재설정하기 원함"
    case noPersonToTalk = "대화할 사람이 없음"
    case payToWin = "결제를 하지 않으면 사용할 수 없음"
    case other
  }
}

public struct ReasonModel {
  public let description: String
  public var isSelected: Bool = false

  public init(_ description: String, isSelected: Bool = false) {
    self.description = description
  }
}


