//
//  NicknameEditVM.swift
//  MyPage
//
//  Created by Kanghos on 7/22/24.
//

import Foundation

import Core

import MyPageInterface

import RxSwift
import RxCocoa

final class NicknameEditVM: ViewModelType {
  private let useCase: MyPageUseCaseInterface
  private let userStore: UserStore
  weak var delegate: MyPageCoordinatingActionDelegate?
  private var disposeBag = DisposeBag()

  init(
    useCase: MyPageUseCaseInterface,
    nickname: String,
    userStore: UserStore
  ) {
    self.useCase = useCase
    self.userStore = userStore
  }

  struct Input {
    let text: Driver<String>
    let nextBtnTap: Signal<Void>
  }

  struct Output {
    let isBtnEnabled: Driver<Bool>
    let errorMessage: Driver<String>
  }

  func transform(input: Input) -> Output {

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
        owner.delegate?.invoke(.popToRoot)
      }.disposed(by: disposeBag)

    return Output(isBtnEnabled: textValidate, errorMessage: errorMessage.asDriverOnErrorJustEmpty())
  }
}
