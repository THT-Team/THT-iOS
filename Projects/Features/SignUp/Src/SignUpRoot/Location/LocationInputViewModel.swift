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
  private let initialValue: LocationReq?

  struct Input {
    let locationBtnTap: Driver<Void>
    let nextBtn: Driver<Void>
  }

  struct Output {
    let isNextBtnEnabled: Driver<Bool>
    let currentLocation: Driver<String>
  }

  init(useCase: SignUpUseCaseInterface, initialLocation: LocationReq?) {
    self.useCase = useCase
    self.initialValue = initialLocation
  }

  // 필드 클릭하면 퍼미션 리퀘스트 후 -> granted: Bool
  // granted 면 시작, 아니면,

  func transform(input: Input) -> Output {
    
    let addressTrigger = self.locationTrigger
    let currentLocation = BehaviorRelay<LocationReq?>(value: self.initialValue)

    input.locationBtnTap
      .throttle(.microseconds(300), latest: false)
      .flatMapLatest { [unowned self] _ in
        self.useCase.fetchLocation()
          .catch { error in
            self.delegate?.invoke(.webViewTap(listner: self))
            return .error(error)
          }
          .asDriver(onErrorDriveWith: .empty())
      }
      .drive(currentLocation)
      .disposed(by: disposeBag)

    addressTrigger
      .asDriverOnErrorJustEmpty()
      .flatMap { [unowned self] address in
        self.useCase.fetchLocation(address)
          .asDriver(onErrorDriveWith: .empty())
      }
      .drive(currentLocation)
      .disposed(by: disposeBag)

    input.nextBtn
      .throttle(.microseconds(300), latest: false)
      .withLatestFrom(currentLocation.asDriver())
      .compactMap { $0 }
      .drive(with: self, onNext: { owner, location in
        owner.delegate?.invoke(.nextAtLocation(location))
      })
      .disposed(by: disposeBag)

    let isNextBtnEnabled = currentLocation
      .compactMap { $0 }
      .map(validator)
      .asDriver(onErrorJustReturn: false)

    return Output(
      isNextBtnEnabled: isNextBtnEnabled,
      currentLocation: currentLocation.compactMap { $0?.address }.asDriverOnErrorJustEmpty()
    )
  }

  func validator(_ location: LocationReq) -> Bool {
    return true
  }
}

extension LocationInputViewModel: WebViewDelegate {
  func didReceiveAddress(_ address: String) {
    self.locationTrigger.onNext(address)
  }
}
