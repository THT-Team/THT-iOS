//
//  AlarmModel.swift
//  MyPage
//
//  Created by Kanghos on 6/16/24.
//

import Foundation

enum AlarmSettingType {
  case marketing
  case alarm

  var title: String {
    switch self {
    case .marketing:
      return "마케팅 알림 수신 동의"
    case .alarm:
      return "알림 설정"
    }
  }
}

struct AlarmSection {
  let title: String?
  var description: String?
  var items: [AlarmSettingCellViewModel]
}

struct AlarmSettingCellViewModel {
  var model: AlarmModel?
  let title: String?
  let secondaryTitle: String?
  var isOn: Bool
}

enum AlarmModel: String {
  case marketingAlarm = "marketingAlarm"
  case newMatchSuccessAlarm = "newMatchSuccessAlarm"
  case likeMeAlarm = "likeMeAlarm"
  case newConversationAlarm = "newConversationAlarm"
  case talkAlarm = "talkAlarm"
  case countdownAlarm = "countdownAlarm"
  case realTimeMatchAlarm = "realTimeMatchAlarm"

  var title: String {
    switch self {
    case .marketingAlarm:
      return "마케팅 정보 수신 동의"
    case .newMatchSuccessAlarm:
      return "새로운 매치"
    case .likeMeAlarm:
      return "나를 좋아요"
    case .newConversationAlarm:
      return "새로운 대화"
    case .talkAlarm:
      return "기존 대화"
    case .countdownAlarm:
      return "카운트다운 진동 알림"
    case .realTimeMatchAlarm:
      return "실시간 매치 진동 알림"
    }
  }

  var secondaryTitle: String? {
    switch self {
    case .marketingAlarm:
      return "폴링에서 다양한 이벤트와 혜택을 알려드립니다."
    case .newMatchSuccessAlarm:
      return "새로운 매치가 되었을 때 알림을 받습니다."
    case .likeMeAlarm:
      return "상대방으로부터 좋아요를 받았을 때 알림을 받습니다."
    case .newConversationAlarm:
      return "새로운 메세지를 받았을 때 알림을 받습니다."
    case .talkAlarm:
      return "기존 대화 메세지를 받았을 때 알림을 받습니다."
    case .countdownAlarm:
      return "유저 카드 카운트 다운 3초부터 진동 알림을 받습니다."
    case .realTimeMatchAlarm:
      return "앱 사용 중 서로 좋아요를 누른 경우 진동 알림을 받습니다."
    }
  }
}
