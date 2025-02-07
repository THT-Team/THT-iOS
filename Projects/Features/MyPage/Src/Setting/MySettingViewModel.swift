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
import Domain

public final class MySettingViewModel: ViewModelType {
  private var disposeBag = DisposeBag()
  private let useCase: MyPageUseCaseInterface
  private let locationUseCase: LocationUseCaseInterface

  private let userStore: UserStore
  var onMenuItem: ((MySetting.Section, MySetting.MenuItem) -> Void)?
  var onBackBtn: (() -> Void)?

  public struct Input {
    let viewDidLoad: Driver<Void>
    let indexPath: Driver<IndexPath>
    let backBtnTap: Signal<Void>
  }

  public struct Output {
    let sections: Driver<[SectionModel<MySetting.MenuItem>]>
    let toast: Driver<String>
  }

  public init(useCase: MyPageUseCaseInterface, locationUseCase: LocationUseCaseInterface, userStore: UserStore) {
    self.useCase = useCase
    self.locationUseCase = locationUseCase
    self.userStore = userStore
  }

  public func transform(input: Input) -> Output {
    let user: Driver<User> = userStore.binding.asDriverOnErrorJustEmpty().compactMap { $0 }
    let toast = PublishRelay<String>()
    let errorTracker = PublishSubject<Error>()

    let sections = user
      .map { [weak self] user in
      self?.useCase.createSettingMenu(user: user) ?? []
    }

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
      .drive(with: self) { owner, component -> Void in
        owner.onMenuItem?(component.section, component.item)
      }.disposed(by: disposeBag)

    input.backBtnTap
      .emit(with: self) { owner, _ in
        owner.onBackBtn?()
      }.disposed(by: disposeBag)

    return Output(
      sections: sections,
      toast: toast.asDriverOnErrorJustEmpty())}
}
