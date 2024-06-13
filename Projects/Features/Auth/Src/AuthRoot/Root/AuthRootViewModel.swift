//
//  SignUpViewModel.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/22.
//

import Foundation

import RxSwift
import RxCocoa
import AuthInterface

import Core

final class AuthRootViewModel: ViewModelType {
  struct Input {
    let buttonTap: Driver<SNSType>
  }

  struct Output {

  }

  weak var delegate: AuthCoordinatingActionDelegate?

  var disposeBag: DisposeBag = DisposeBag()

  func transform(input: Input) -> Output {
    input.buttonTap
      .drive(with: self, onNext: { owner, sns in
        owner.delegate?.invoke(.tologinType(sns))
      })
      .disposed(by: disposeBag)

    return Output()
  }
}
