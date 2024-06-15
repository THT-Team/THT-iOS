//
//  AlarmSettingViewModel.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/14/24.
//

import Foundation

import Core

import RxSwift
import RxCocoa

final class AlarmSettingViewModel: ViewModelType {

  private var disposeBag = DisposeBag()

  func transform(input: Input) -> Output {
    let toast = PublishRelay<String>()
    let alarmSection = PublishRelay<[AlarmSection]>()
    let updateDate = PublishRelay<Date>()
    var state = PublishRelay<[String: Bool]>()

    let initialState = input.viewDidLoad
      .flatMap { [unowned self] _ in
        Signal.just(self.initialState)
      }

    initialState
      .emit(to: state)
      .disposed(by: disposeBag)

    initialState
      .map(transformAlarmSetting(_:))
      .emit(to: alarmSection)
      .disposed(by: disposeBag)

    input.tap
      .withLatestFrom(state.asSignal())

    return Output(
      toast: toast.asSignal(),
      updateDate: updateDate.asDriver(onErrorJustReturn: Date()),
      alarmSection: alarmSection.asDriver(onErrorJustReturn: [])
    )
  }

  func transformAlarmSetting(_ alarmSetting: [String: Bool]) -> [AlarmSection] {
    var pairs = alarmSetting
    var sections: [AlarmSection] = []
    var marketingSection = AlarmSection(
      title: "마케팅 알람 설정",
      description: "폴링에서 다양한 이벤트와 혜택을 알려드립니다.",
      items: []
    )
    var alarmSection = AlarmSection(title: "알람 설정", description: nil, items: [])

    pairs.forEach { pair in
      if pair.key == "marketingAlarm" {
        let item = AlarmSettingCellViewModel(title: "마케팅 알림 수신 동의", secondaryTitle: nil, isOn: pair.value)
        marketingSection.items.append(item)
      } else {
        let item = AlarmSettingCellViewModel(title: pair.key, secondaryTitle: "secondary", isOn: pair.value)
        alarmSection.items.append(item)
      }
    }
    sections.append(contentsOf: [marketingSection, alarmSection])
    return sections
  }
}

extension AlarmSettingViewModel {
  struct Input {
    let viewDidLoad: Signal<Void>
    let tap: Signal<String>
  }

  struct Output {
    let toast: Signal<String>
    let updateDate: Driver<Date>
    let alarmSection: Driver<[AlarmSection]>
  }

  var initialState: [String: Bool] {
    [
      "marketingAlarm": true,
      "newMatchSuccessAlarm": true,
      "likeMeAlarm": true,
      "newConversationAlarm": true,
      "talkAlarm": true
    ]
  }
}

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

enum AlarmModel: String {
  case marketingAlarm = "marketingAlarm"
  case newMatchSuccessAlarm = "newMatchSuccessAlarm"
  case likeMeAlarm = "likeMeAlarm"
  case newConversationAlarm = "newConversationAlarm"
  case talkAlarm = "talkAlarm"

  var title: String {
    switch self {
    case .marketingAlarm:
      return "마케팅 알림 수신 동의"
    case .newMatchSuccessAlarm:
      return "매칭 성공 알림"
    case .likeMeAlarm:
      return "나를 좋아요 알림"
    case .newConversationAlarm:
      return "새로운 대화 알림"
    case .talkAlarm:
      return "톡 알림"
    }
  }
}

struct AlarmSection {
  let title: String?
  let description: String?
  var items: [AlarmSettingCellViewModel]
}

struct AlarmSettingCellViewModel {
  let title: String?
  let secondaryTitle: String?
  let isOn: Bool
}
