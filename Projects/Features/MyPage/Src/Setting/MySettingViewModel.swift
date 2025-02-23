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

  deinit {
    TFLogger.cycle(name: self)
  }

  public func transform(input: Input) -> Output {
    let user: Driver<User> = userStore.binding.asDriverOnErrorJustEmpty().compactMap { $0 }
    let toast = PublishRelay<String>()

    let sections = user.map { [weak self] user in
      self?.useCase.createSettingMenu(user: user) ?? []
    }

    let selectedItem = input.indexPath
      .withLatestFrom(sections) { indexPath, sections in
        let section = sections[indexPath.section].type
        let menu = sections[indexPath.section].items[indexPath.item]
        return (section: section, item: menu)
      }
      .asObservable()

    selectedItem
      .filter { $0.0 == .location }
      .withLatestFrom(user.map { $0.address })
      .withUnretained(self)
      .flatMap { owner, address in
        owner.locationUseCase.fetchLocation()
          .asObservable()
          .catch({ error in
            toast.accept(error.localizedDescription)
            return .empty()
          })
      }
      .withUnretained(self)
      .flatMap { owner, request in
        owner.useCase.updateLocation(request)
          .asObservable()
          .catch({ error in
            toast.accept(error.localizedDescription)
            return .empty()
          })
      }
      .map { _ in "현재 위치가 업데이트 되었습니다." }
      .bind(to: toast)
      .disposed(by: disposeBag)

    selectedItem
      .asDriverOnErrorJustEmpty()
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
