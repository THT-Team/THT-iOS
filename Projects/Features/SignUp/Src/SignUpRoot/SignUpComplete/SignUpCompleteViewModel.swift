//
//  SignUpCompleteViewModel.swift
//  SignUpInterface
//
//  Created by Kanghos on 5/28/24.
//

import Foundation

import Core

import RxSwift
import RxCocoa

import SignUpInterface
import AuthInterface
import Domain

final class SignUpCompleteViewModel: BasePenddingViewModel, ViewModelType {

  var onNext: (() -> Void)?

  struct Input {
    let nextBtnTap: Driver<Void>
  }

  struct Output {
    let toast: Signal<String>
    let profileImage: Driver<Data?>
  }

  func transform(input: Input) -> Output {
    let toast = PublishRelay<String>()
    let profileImage = BehaviorRelay<Data?>(value: nil)


    useCase.fetchUserPhotos(key: pendingUser.phoneNumber, fileNames: pendingUser.photos)
      .subscribe { data in
        profileImage.accept(data.first)
      } onFailure: { error in
        toast.accept(error.localizedDescription)
      }
      .disposed(by: disposeBag)

    input.nextBtnTap
      .throttle(.milliseconds(500), latest: false)
      .drive(with: self) { owner, _ in
        owner.onNext?()
      }
      .disposed(by: disposeBag)

    return Output(
      toast: toast.asSignal(),
      profileImage: profileImage.asDriver()
    )
  }
}
