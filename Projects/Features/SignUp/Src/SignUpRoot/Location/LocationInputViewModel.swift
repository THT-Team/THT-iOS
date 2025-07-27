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
import AuthInterface
import Domain

final class LocationInputViewModel: BasePenddingViewModel, ViewModelType {

  private let locationTrigger = PublishSubject<String>()
  private let locationUseCase: LocationUseCaseInterface

  struct Input {
    let locationBtnTap: Signal<Void>
    let nextBtn: Signal<Void>
  }

  struct Output {
    let isNextBtnEnabled: Driver<Bool>
    let currentLocation: Driver<String>
  }

  required init(useCase: SignUpUseCaseInterface, locationUseCase: LocationUseCaseInterface, pendingUser: PendingUser) {
    self.locationUseCase = locationUseCase
    super.init(useCase: useCase, pendingUser: pendingUser)
  }

  // 필드 클릭하면 퍼미션 리퀘스트 후 -> granted: Bool
  // granted 면 시작, 아니면,

  func transform(input: Input) -> Output {
    let errorTracker = PublishSubject<Error>()
    let toast = PublishSubject<String>()
    let addressTrigger = self.locationTrigger
    let inivialValue = useCase.fetchPendingUser()?.address

    let currentLocation = BehaviorRelay<LocationReq?>(value: inivialValue)
    let currentLocationShare = currentLocation.asDriver()

    input.locationBtnTap
      .throttle(.milliseconds(500), latest: false)
      .asObservable()
      .withUnretained(self)
      .debug("fetch btn tap!")
      .observe(on: MainScheduler.instance)
//      .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
      .flatMapLatest { owner, _ in
        return owner.locationUseCase.fetchLocation()
          .debug("location usecase")
          .asObservable()
          .catch { error in
            errorTracker.onNext(error)
            return .empty()
          }
      }
      .bind(to: currentLocation)
      .disposed(by: disposeBag)

    errorTracker
      .compactMap { [weak self] error -> String? in
        guard let self else { return nil }
        if let error = error as? LocationError {
          switch error {
          case .denied:
            self.delegate?.invoke(.webViewTap(listner: self), self.pendingUser)
            return "위치 권한을 허용해주세요."
          case .invalidLocation:
            return "올바르지 않은 위치입니다."
          case .notDetermined:
            return nil
          }
        } else {
          return "알 수 없는 에러."
        }
      }.asSignal(onErrorSignalWith: .empty())
      .emit(to: toast)
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
      .emit(with: self, onNext: { owner, location in
        owner.pendingUser.address = location
        owner.useCase.savePendingUser(owner.pendingUser)
        owner.delegate?.invoke(.nextAtLocation, owner.pendingUser)
      })
      .disposed(by: disposeBag)

    let isNextBtnEnabled = currentLocationShare
      .flatMapLatest(with: self) { owner, location in
        owner.locationUseCase.isValid(location)
          .asDriver(onErrorJustReturn: false)
      }

    return Output(
      isNextBtnEnabled: isNextBtnEnabled,
      currentLocation: currentLocationShare.compactMap { $0?.address }
    )
  }
}

extension LocationInputViewModel: WebViewDelegate {
  func didReceiveAddress(_ address: String) {
    self.locationTrigger.onNext(address)
  }
}
