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
  weak var delegate: MyPageCoordinatingActionDelegate?
  private let user: User

  struct Input {
    let viewDidLoad: Driver<Void>
    let indexPath: Driver<IndexPath>
  }
  
  struct Output {
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

    input.indexPath
      .compactMap { MySetting.Section(rawValue: $0.section) }
      .filter { $0 == .location }
      .throttle(.milliseconds(300), latest: false)
      .withLatestFrom(user.map { $0.address })
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.locationUseCase.fetchLocation()
          .map({ lo in
            return lo
          })
          .asObservable()
          .map { location in
            toast.accept("현재 위치가 업데이트 되었습니다.")
            return location
          }
          .catch { error in
            TFLogger.dataLogger.error("\(error.localizedDescription)")
            toast.accept("위치를 불러올 수 없습니다.")
            return .empty()
          }
      }.asDriverOnErrorJustEmpty()
      .drive()
      .disposed(by: disposeBag)


    input.indexPath
      .drive(with: self) { owner, indexPath in
        owner.navigate(indexPath: indexPath)
      }.disposed(by: disposeBag)

    return Output(toast: toast.asDriverOnErrorJustEmpty())
  }

  func navigate(indexPath: IndexPath) {
    guard let section = MySetting.Section(rawValue: indexPath.section) else {
      return
    }

    switch section {
    case .account:
        break
    case .activity:
      self.delegate?.invoke(.editUserContacts)
    case .location:
      break
    case .notification:
      TFLogger.dataLogger.debug("notification")
    case .support:
      TFLogger.dataLogger.debug("support")
    case .law:
      TFLogger.dataLogger.debug("url \(indexPath.item)")
    case .accoutSetting:
      TFLogger.dataLogger.debug("account Setting/")
    }
  }
}
