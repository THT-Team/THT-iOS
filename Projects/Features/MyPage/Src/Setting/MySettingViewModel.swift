//
//  MySettingViewModel.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/9/24.
//

import Foundation
import MyPageInterface
import SignUpInterface

import Core

import RxSwift
import RxCocoa

final class MySettingViewModel: ViewModelType {
  private var disposeBag = DisposeBag()
  private let useCase: MyPageUseCaseInterface
  private let locationUseCase: LocationUseCaseInterface
  weak var delegate: MySettingCoordinatingActionDelegate?
  private let user: User

  struct Input {
    let viewDidLoad: Driver<Void>
    let indexPath: Driver<IndexPath>
    let backBtnTap: Signal<Void>
  }

  struct Output {
    let sections: Driver<[SectionModel<MySetting.MenuItem>]>
    let toast: Driver<String>
  }

  init(useCase: MyPageUseCaseInterface, locationUseCase: LocationUseCaseInterface, user: User) {
    self.useCase = useCase
    self.locationUseCase = locationUseCase
    self.user = user
  }

  func transform(input: Input) -> Output {
    let user = Driver.just(self.user)
    let toast = PublishRelay<String>()
    let errorTracker = PublishSubject<Error>()

    let sections = user.map(makeStaticSettingMenus(user:))

    input.indexPath
      .compactMap { MySetting.Section(rawValue: $0.section) }
      .filter { $0 == .location }
      .throttle(.milliseconds(600), latest: false)
      .withLatestFrom(user.map { $0.address })
      .flatMapLatest(with: self) { owner, _ in
        owner.locationUseCase.fetchLocation()
          .map { location in
            toast.accept("현재 위치가 업데이트 되었습니다.")
            return location
          }
          .asDriver(onErrorRecover: { error in
            errorTracker.onNext(error)
            return .empty()
          })
      }
      .flatMapLatest(with: self) { owner, location in
        owner.useCase.updateLocation(location)
          .asDriver(onErrorRecover: { error in
            errorTracker.onNext(error)
            return .empty()
          })
      }
      .drive()
      .disposed(by: disposeBag)

    errorTracker
      .compactMap { error -> String? in
        if let error = error as? LocationError {
          switch error {
          case .denied:
            return "위치 권한을 허용해주세요."
          case .invalidLocation:
            return "올바르지 않은 위치입니다."
          case .notDetermined:
            return nil
          }
        } else {
          return "알 수 없는 에러."
        }
      }
      .asSignal(onErrorSignalWith: .empty())
      .emit(to: toast)
      .disposed(by: disposeBag)

    input.indexPath
      .withLatestFrom(sections) { indexPath, sections in
        let section = sections[indexPath.section].type
        let menu = sections[indexPath.section].items[indexPath.item]

        return (section: section, item: menu)
      }
      .drive(with: self) { owner, component in
        owner.navigate(section: component.section, item: component.item)
      }.disposed(by: disposeBag)

    input.backBtnTap
      .emit(with: self) { owner, _ in
        owner.delegate?.invoke(.finish)
      }.disposed(by: disposeBag)

    return Output(
      sections: sections,
      toast: toast.asDriverOnErrorJustEmpty())}
}

extension MySettingViewModel {

  func navigate(section: MySetting.Section, item: MySetting.MenuItem) {
    switch section {
    case .account:
      break
    case .activity:
      self.delegate?.invoke(.editUserContacts)
    case .location:
      break
    case .notification:
      self.delegate?.invoke(.alarmSetting)
    case .support, .law:
      guard let url = item.url else {
        self.delegate?.invoke(.feedback)
        return
      }
      self.delegate?.invoke(.webView(.init(title: item.title, url: url)))
    case .accoutSetting:
      self.delegate?.invoke(.accountSetting)
    }
  }

  func makeStaticSettingMenus(user: User) -> [SectionModel<MySetting.MenuItem>] {
    return [
      SectionModel(
        type: .account,
        items: [
          .item(MySetting.Item(title: "연동된 SNS", content: "Google")),
        ]),
      SectionModel(
        type: .activity,
        items: [.item(MySetting.Item(title: "저장된 연락처 차단하기"))]),
      SectionModel(
        type: .location,
        items: [.item(MySetting.Item(title: "위치 설정", content: user.address))]),
      SectionModel(
        type: .notification,
        items: [.item(MySetting.Item(title: "알림 설정"))]),
      SectionModel(
        type: .support,
        items: [
          .linkItem(MySetting.LinkItem(title: "자주 묻는 질문", url: URL(string: "https://www.notion.so/janechoi/46bf7dbf13da4ca5a2e8dc44a5fb9236?pvs=4")!)),
          .item(MySetting.Item(title: "문의 및 피드백 보내기"))]),
      SectionModel(
        type: .law,
        items: [
          .linkItem(MySetting.LinkItem(title: "서비스 이용약관", url: URL(string: "https://www.notion.so/janechoi/46bf7dbf13da4ca5a2e8dc44a5fb9236?pvs=4")!)),
          .linkItem(MySetting.LinkItem(title: "개인정보 처리방침", url: URL(string: "https://www.notion.so/janechoi/46bf7dbf13da4ca5a2e8dc44a5fb9236?pvs=4")!)),
          .linkItem(MySetting.LinkItem(title: "위치정보 이용약관", url: URL(string: "https://www.notion.so/janechoi/46bf7dbf13da4ca5a2e8dc44a5fb9236?pvs=4")!)),
          .linkItem(MySetting.LinkItem(title: "라이센스", url: URL(string: "https://www.notion.so/janechoi/46bf7dbf13da4ca5a2e8dc44a5fb9236?pvs=4")!)),
          .linkItem(MySetting.LinkItem(title: "사업자 정보", url: URL(string: "http://www.ftc.go.kr/bizCommPop.do?wrkr_no=6806400545")!))]),
      SectionModel(
        type: .accoutSetting,
        items: [.item(MySetting.Item(title: "계정 설정"))]),
    ]
  }
}

struct SectionModel<ItemType> where ItemType: MenuType {
  let type: MySetting.Section
  let items: [ItemType]
}
