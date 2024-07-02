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
import MyPageInterface

final class AlarmSettingViewModel: ViewModelType {

  private let myPageUseCase: MyPageUseCaseInterface
  private var disposeBag = DisposeBag()
  weak var delegate: MySettingCoordinatingActionDelegate?

  init(myPageUseCase: MyPageUseCaseInterface) {
    self.myPageUseCase = myPageUseCase
  }

  func transform(input: Input) -> Output {
    let toast = PublishRelay<String>()
    let updateMarketingSection = PublishRelay<AlarmSection>()
    let initialState = myPageUseCase.fetchAlarmSetting()
    let state = BehaviorRelay<[String: Bool]>(value: initialState.settings)
    let marketAlarmDidChange = PublishRelay<Bool>()

    // TODO: Local Storage에서 가져와야함. 동의 Dictionary와 라스트 날짜

    let alarmSection = Driver.just(initialState)
      .map(transformAlarmSetting(_:))

    input.tap
      .asDriver(onErrorDriveWith: .empty())
      .withLatestFrom(alarmSection) { indexPath, sections in
        let selected = sections[indexPath.section].items[indexPath.item]
        return selected.model
      }
      .compactMap { $0 }
      .withLatestFrom(state.asDriver()) { model, state in
        var newState = state
        newState.merge([model.rawValue: !state[model.rawValue]!]) { _, new in new }
        return newState
      }
      .drive(state)
      .disposed(by: disposeBag)

    state
      .asDriver()
      .skip(1)
      .debounce(.milliseconds(500))
      .scan(initialState.settings) { last, new in // TODO: initialState를 어떻게 가져가야할지도 고민
        let key = AlarmModel.marketingAlarm.rawValue
        if last[key] != new[key] {
          let isAgree = new[key] ?? false
          marketAlarmDidChange.accept(isAgree)
        }
        return new
      }
      .map { AlarmSetting(settings: $0, lastUpdated: Date()) }
      .flatMapLatest(with: self) { owner, model in
        owner.myPageUseCase.saveAlarmSetting(model)
          .catch { error in
            toast.accept("업데이트 실패")
            return .empty()
          }
          .asDriver(onErrorDriveWith: .empty())
      }.drive()
      .disposed(by: disposeBag)

    marketAlarmDidChange
      .map { _ in Date().toKoreanDateString() + " 마케팅 알림 설정이 변경되었습니다." }
      .asSignal(onErrorSignalWith: .empty())
      .emit(to: toast)
      .disposed(by: disposeBag)

    let marketingDescription = marketAlarmDidChange
      .map { isAgree in
        let date = Date().toKoreanDateString()

        return isAgree
        ? "수신 동의일 " + date
        : "수신 거부일 " + date
      }

    return Output(
      toast: toast.asSignal(),
      marketingDescription: marketingDescription.asDriverOnErrorJustEmpty(),
      alarmSection: alarmSection.asDriver(onErrorJustReturn: [])
    )
  }

  func transformAlarmSetting(_ alarmSetting: AlarmSetting) -> [AlarmSection] {
    let lastUpdated = alarmSetting.lastUpdated ?? Date()
    var sections: [AlarmSection] = []
    var marketingSection = AlarmSection(
      title: "마케팅 알람 설정",
      description: nil,
      items: []
    )
    var alarmSection = AlarmSection(title: "알람 설정", description: nil, items: [])

    alarmSetting.settings.forEach { pair in
      if let alarm = AlarmModel(rawValue: pair.key) {
        let item = AlarmSettingCellViewModel(model: alarm, title: alarm.title, secondaryTitle: alarm.secondaryTitle, isOn: pair.value)
        if pair.key == "marketingAlarm" {
            marketingSection.items.append(item)
          let description = item.isOn
          ? "수신 동의일 " + lastUpdated.toKoreanDateString()
          : "수신 거부일 " + lastUpdated.toKoreanDateString()
          marketingSection.description = description
          } else {
          alarmSection.items.append(item)
        }
      }
    }
    sections.append(contentsOf: [marketingSection, alarmSection])
    return sections
  }
}

extension AlarmSettingViewModel {
  struct Input {
    let tap: Signal<IndexPath>
  }

  struct Output {
    let toast: Signal<String>
    let marketingDescription: Driver<String>
    let alarmSection: Driver<[AlarmSection]>
  }
}
