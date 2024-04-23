//
//  NicknameViewModel.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/12.
//

import Foundation

import Core

import RxCocoa
import RxSwift

protocol NicknameInputDelegate: AnyObject {
  func nicknameNextButtonTap()
}

final class NicknameInputViewModel: ViewModelType {

  weak var delegate: NicknameInputDelegate?

  private var disposeBag = DisposeBag()

  struct Input {
    let viewWillAppear: Driver<Void>
    let nickname: Driver<String>
    let clearBtn: Driver<Void>
    let nextBtn: Driver<Void>
  }

  struct Output {
    let validate: Driver<Bool>
  }

  func transform(input: Input) -> Output {
    let text = input.nickname

    let validate = text.map { !$0.isEmpty }

    input.nextBtn
      .drive(with: self) { owner, _ in
      owner.delegate?.nicknameNextButtonTap()
      }
      .disposed(by: disposeBag)

    return Output(
      validate: validate
    )
  }
}
