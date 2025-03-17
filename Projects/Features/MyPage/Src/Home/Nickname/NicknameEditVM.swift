//
//  NicknameEditVM.swift
//  MyPage
//
//  Created by Kanghos on 7/22/24.
//

import Foundation

import Core

import MyPageInterface
import Domain

import RxSwift
import RxCocoa

public final class NicknameEditVM: ViewModelType {
  private let useCase: MyPageUseCaseInterface
  private let userStore: UserStore
  private var disposeBag = DisposeBag()

  var onComplete: (() -> Void)?

  public init(
    useCase: MyPageUseCaseInterface,
    nickname: String,
    userStore: UserStore
  ) {
    self.useCase = useCase
    self.userStore = userStore
  }

  public struct Input {
    let text: Driver<String>
    let nextBtnTap: Signal<Void>
  }

  public struct Output {
    let isBtnEnabled: Driver<Bool>
    let errorMessage: Driver<String>
  }

  public func transform(input: Input) -> Output {

    let errorMessage = RxSwift.PublishSubject<String>()
    let text = input.text
      .debounce(.milliseconds(300))
      .distinctUntilChanged()
    let textValidate = text
      .flatMapLatest(with: self) { owner, text in
        owner.useCase.checkNickname(text)
          .asDriver { error in
            errorMessage.onNext(error.localizedDescription)
            return .just(false)
          }
      }

    input.nextBtnTap
      .throttle(.milliseconds(500), latest: false)
      .asDriver(onErrorDriveWith: .empty())
      .withLatestFrom(text)
      .flatMapLatest(with: self) { owner, text in
        owner.useCase.updateNickname(text)
          .map { text }
          .asDriver { error in
            errorMessage.onNext(error.localizedDescription)
            return .empty()
          }
      }
      .drive(with: self) { owner, text in
        owner.userStore.send(action: .nickname(text))
        owner.onComplete?()
      }.disposed(by: disposeBag)

    return Output(isBtnEnabled: textValidate, errorMessage: errorMessage.asDriverOnErrorJustEmpty())
  }
}
