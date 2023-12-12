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

  struct Input {
    let viewWillAppear: Driver<Void>
    let nickname: Driver<String>
    let clearBtn: Driver<Void>
    let nextBtn: Driver<Void>
  }

  struct Output {

  }

  func transform(input: Input) -> Output {

    return Output()
  }
}
