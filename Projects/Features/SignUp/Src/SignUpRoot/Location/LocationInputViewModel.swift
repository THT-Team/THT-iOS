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
  
  private let locationTrigger = PublishSubject<String>()

  struct Input {
    let locationBtnTap: Driver<Void>
    let nextBtn: Driver<Void>
  }

  struct Output {
    let isNextBtnEnabled: Driver<Bool>
    let currentLocation: Driver<String>
  }

  init(locationservice: LocationServiceType) {
    self.locationService = locationservice
  }

  func transform(input: Input) -> Output {
    
    Driver.just(Void())
      .drive(with: self) { owner, _ in
        owner.locationService.requestAuthorization()
      }.disposed(by: disposeBag)
    
    let currentLocation = Observable<String>.merge(locationService.publisher, self.locationTrigger)
      .asDriver(onErrorJustReturn: "")
    let webViewTrigger = PublishSubject<Void>()

    input.locationBtnTap
      .drive(with: self, onNext: { owner, _ in
        owner.locationService.handleAuthorization { granted in
          if granted {
            owner.locationService.requestLocation()
          } else {
            owner.delegate?.invoke(.webViewTap(listner: owner))
          }
        }
      })
      .disposed(by: disposeBag)

    input.nextBtn
      .withLatestFrom(currentLocation)
      .drive(with: self, onNext: { owner, location in
        owner.delegate?.invoke(.nextAtLocation(.init(address: location, regionCode: 0, lat: 0, lon: 0)))
      })
      .disposed(by: disposeBag)

    let isNextBtnEnabled = currentLocation
      .map { !$0.isEmpty }

    return Output(
      isNextBtnEnabled: isNextBtnEnabled,
      currentLocation: currentLocation
    )
  }
}

extension LocationInputViewModel: WebViewDelegate {
  func didReceiveAddress(_ address: String) {
    self.locationTrigger.onNext(address)
  }
}
