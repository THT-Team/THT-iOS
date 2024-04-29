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
  private let locationService: LocationServiceType
  weak var delegate: SignUpCoordinatingActionDelegate?

  struct Input {
    let locationBtnTap: Driver<Void>
    let nextBtn: Driver<Void>
  }

  struct Output {
    let isNextBtnEnabled: Driver<Bool>
  }

  init(locationservice: LocationServiceType) {
    self.locationService = locationservice
  }

  func transform(input: Input) -> Output {

    let currentLocation = input.locationBtnTap
      .asObservable()
      .withUnretained(self)
      .flatMapLatest({ owner, _ in
        owner.locationService.fetchLocation()
      })
      .asDriverOnErrorJustEmpty()

    input.nextBtn
      .withLatestFrom(currentLocation)
      .drive(with: self, onNext: { owner, location in
        owner.delegate?.invoke(.nextAtLocation(location))
      })
      .disposed(by: disposeBag)

    let isNextBtnEnabled = currentLocation
      .asObservable()
      .withUnretained(self)
      .flatMapLatest { owner, location in
        owner.locationService.isValid(location)
      }.asDriver(onErrorJustReturn: false)

    return Output(
      isNextBtnEnabled: isNextBtnEnabled
    )
  }
}
