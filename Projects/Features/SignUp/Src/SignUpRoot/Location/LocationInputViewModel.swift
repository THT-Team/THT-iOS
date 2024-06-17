//
//  LocationInputViewModel.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/27.
//

import Foundation

import Core

import RxSwift
import RxCocoa
import SignUpInterface

final class LocationInputViewModel: ViewModelType {
  private var disposeBag = DisposeBag()
  weak var delegate: SignUpCoordinatingActionDelegate?

  private let locationTrigger = PublishSubject<String>()
  private let useCase: SignUpUseCaseInterface
  private let userInfoUseCase: UserInfoUseCaseInterface
  private let locationUseCase: LocationUseCaseInterface

  struct Input {
    let locationBtnTap: Driver<Void>
    let nextBtn: Driver<Void>
  }

  struct Output {
    let isNextBtnEnabled: Driver<Bool>
    let currentLocation: Driver<String>
  }

  init(useCase: SignUpUseCaseInterface, userInfoUseCase: UserInfoUseCaseInterface, locationUseCase: LocationUseCaseInterface) {
    self.useCase = useCase
    self.userInfoUseCase = userInfoUseCase
    self.locationUseCase = locationUseCase
  }

  // 필드 클릭하면 퍼미션 리퀘스트 후 -> granted: Bool
  // granted 면 시작, 아니면,

  func transform(input: Input) -> Output {

    let addressTrigger = self.locationTrigger
    let currentLocation = BehaviorRelay<LocationReq?>(value: nil)

    let userinfo = Driver.just(())
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.userInfoUseCase.fetchUserInfo()
          .catchAndReturn(UserInfo(phoneNumber: ""))
          .asObservable()
      }
      .asDriverOnErrorJustEmpty()

    userinfo.map { $0.address }
      .drive(currentLocation)
      .disposed(by: disposeBag)

    input.locationBtnTap
      .throttle(.milliseconds(500), latest: false)
      .asObservable()
      .withUnretained(self)
      .flatMapLatest { owner, _ in

        return owner.locationUseCase.fetchLocation()
          .debug("location usecase")
          .catch { error in
            print(error.localizedDescription)
            owner.delegate?.invoke(.webViewTap(listner: self))
            return .error(error)
          }
          .asDriver(onErrorDriveWith: .empty())
      }
      .asDriverOnErrorJustEmpty()
      .drive(currentLocation)
      .disposed(by: disposeBag)

    addressTrigger
      .asDriverOnErrorJustEmpty()
      .flatMap { [unowned self] address in
        self.locationUseCase.fetchLocation(address: address)
          .asDriver(onErrorDriveWith: .empty())
      }
      .drive(currentLocation)
      .disposed(by: disposeBag)

    input.nextBtn
      .throttle(.milliseconds(300), latest: false)
      .withLatestFrom(currentLocation.asDriver())
      .withLatestFrom(userinfo) { location, userinfo in
        var mutable = userinfo
        mutable.address = location
        return mutable
      }
      .drive(with: self, onNext: { owner, userinfo in
        owner.userInfoUseCase.updateUserInfo(userInfo: userinfo)
        owner.delegate?.invoke(.nextAtLocation)
      })
      .disposed(by: disposeBag)

    let isNextBtnEnabled = currentLocation
      .map(validator)
      .asDriver(onErrorJustReturn: false)

    return Output(
      isNextBtnEnabled: isNextBtnEnabled,
      currentLocation: currentLocation.compactMap { $0?.address }.asDriverOnErrorJustEmpty()
    )
  }

  func validator(_ location: LocationReq?) -> Bool {
    guard
      let location,
      location.address.isEmpty == false,
      location.lat != 0, location.lon != 0
    else { return false }
    return true
  }
}

extension LocationInputViewModel: WebViewDelegate {
  func didReceiveAddress(_ address: String) {
    self.locationTrigger.onNext(address)
  }
}
