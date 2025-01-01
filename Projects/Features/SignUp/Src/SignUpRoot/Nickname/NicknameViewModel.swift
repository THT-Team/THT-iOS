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

final class NicknameInputViewModel: BasePenddingViewModel, ViewModelType {

  struct Input {
    let nickname: Driver<String>
    let nextBtn: Driver<Void>
  }

  struct Output {
    let initialValue: Driver<String?>
    let validate: Driver<Bool>
    let errorField: Driver<String>
  }

  func transform(input: Input) -> Output {
    let text = input.nickname
    let errorTracker = PublishSubject<Error>()
    let outputText = BehaviorRelay<String?>(value: nil)

    let initialNickname = Driver.just(pendingUser.name)

    let isDuplicate = text
      .debounce(.milliseconds(500))
      .distinctUntilChanged()
      .filter(validateNickname)
      .flatMapLatest(with: self) { owner, text in
        owner.useCase.checkNickname(nickname: text)
          .asDriver(onErrorRecover: { error in
            errorTracker.onNext(error)
            return .empty()
          })
      }

    let isAvailableNickname = isDuplicate.map { $0 == false }

    isDuplicate
      .filter { $0 }
      .debug("isDuplicate to ErrorTracker")
      .map { _ in SignUpError.duplicateNickname }
      .drive(errorTracker)
      .disposed(by: disposeBag)

    input.nextBtn
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(isAvailableNickname).filter { $0 }
      .withLatestFrom(text)
      .drive(with: self) { owner, text in
        owner.pendingUser.name = text
        owner.useCase.savePendingUser(owner.pendingUser)
        owner.delegate?.invoke(.nextAtNickname, owner.pendingUser)
      }
      .disposed(by: disposeBag)
    
    let errorField = errorTracker
      .compactMap { error in
        switch error {
        case SignUpError.duplicateNickname:
          return "이미 사용중인 닉네임입니다."
        default:
          return error.localizedDescription
        }
      }.asDriverOnErrorJustEmpty()

    return Output(
      initialValue: initialNickname,
      validate: isAvailableNickname,
      errorField: errorField
    )
  }

  func validateNickname(_ text: String) -> Bool {
    !text.isEmpty && text.count < 13 && text.count > 1
  }
}
