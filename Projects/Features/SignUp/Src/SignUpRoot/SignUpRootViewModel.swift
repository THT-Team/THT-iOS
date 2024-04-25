//
//  SignUpViewModel.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/22.
//

import Foundation

import RxSwift
import RxCocoa

import Core

final class SignUpRootViewModel: ViewModelType {
  struct Input {
    let phoneBtn: Driver<Void>
    let kakaoBtn: Driver<Void>
    let googleBtn: Driver<Void>
    let naverBtn: Driver<Void>
  }

  struct Output {

  }

  weak var delegate: SignUpCoordinatingActionDelegate?

  var disposeBag: DisposeBag = DisposeBag()

  func transform(input: Input) -> Output {
    input.phoneBtn
      .drive(with: self, onNext: { owner, _ in
        owner.delegate?.invoke(.phoneNumber)
      })
      .disposed(by: disposeBag)

    input.kakaoBtn
      .drive(onNext: { [weak self] in
        guard let self else { return }
        print("kakao button")
      })
      .disposed(by: disposeBag)

    input.naverBtn
      .drive(onNext: { [weak self] in
        guard let self else { return }
        print("naver button")
      })
      .disposed(by: disposeBag)

    input.googleBtn
      .drive(onNext: { [weak self] in
        guard let self else { return }
        print("google button")
      })
      .disposed(by: disposeBag)

    return Output()
  }
}
