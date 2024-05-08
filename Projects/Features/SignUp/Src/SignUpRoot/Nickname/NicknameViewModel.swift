//
//  NicknameViewModel.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/12.
//

import Foundation
import SignUpInterface

import Core

import RxCocoa
import RxSwift

final class NicknameInputViewModel: ViewModelType {
  private let useCase: SignUpUseCaseInterface

  weak var delegate: SignUpCoordinatingActionDelegate?

  private var disposeBag = DisposeBag()
  
  init(useCase: SignUpUseCaseInterface) {
    self.useCase = useCase
  }

  struct Input {
    let viewWillAppear: Driver<Void>
    let nickname: Driver<String>
    let clearBtn: Driver<Void>
    let nextBtn: Driver<Void>
  }

  struct Output {
    let validate: Driver<Bool>
    let errorField: Driver<String>
  }

  func transform(input: Input) -> Output {
    let text = input.nickname
    let errorTracker = PublishSubject<Error>()
    
    input.viewWillAppear
      .drive()
      .disposed(by: disposeBag)

    let validate = text
      .distinctUntilChanged()
      .filter { !$0.isEmpty && $0.count < 13 }
      .throttle(.milliseconds(500), latest: false)
      .flatMapLatest { [unowned self] text in
        self.useCase.checkNickname(nickname: text)
          .catch({ error in
            errorTracker.onNext(error)
            return .just(false)
          })
          .asDriver(onErrorJustReturn: false)
      }
    let latest = Driver.zip(text, validate) { text, validate in
      return text
    }

    input.nextBtn
      .withLatestFrom(latest)
      .drive(with: self) { owner, text in
        owner.delegate?.invoke(.nextAtNickname(text))
      }
      .disposed(by: disposeBag)
    
    let errorField = errorTracker
      .compactMap { error in
        switch error {
        case SignUpError.duplicateNickname:
          return "이미 사용중인 닉네임입니다."
        default:
          return nil
        }
      }.asDriverOnErrorJustEmpty()

    return Output(
      validate: validate,
      errorField: errorField
    )
  }
}
