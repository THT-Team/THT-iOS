//
//  IntroduceVM.swift
//  MyPage
//
//  Created by Kanghos on 7/22/24.
//

import Foundation

import Core

import MyPageInterface

import RxSwift
import RxCocoa

public final class IntroduceEditVM: ViewModelType {
  private let useCase: MyPageUseCaseInterface
  private var disposeBag = DisposeBag()
  private let initialValue: String
  private let userStore: UserStore

  public init(
    useCase: MyPageUseCaseInterface,
    introduce: String,
    userStore: UserStore
  ) {
    self.useCase = useCase
    self.initialValue = introduce
    self.userStore = userStore
  }
  var onComplete: (() -> Void)?

  public struct Input {
    let text: Driver<String>
    let nextBtnTap: Signal<Void>
  }

  public struct Output {
    let isBtnEnabled: Driver<Bool>
    let errorMessage: Driver<String>
    let initialText: Driver<String>
  }

  public func transform(input: Input) -> Output {
    let initialText = Driver.just(self.initialValue)

    let errorMessage = RxSwift.PublishSubject<String>()
    let text = input.text.debounce(.milliseconds(300)).debug("textStream")
    let textValidate = Driver.combineLatest(initialText, text.skip(1)) {
      print(initialText)
      print()
      print(text)
      print("textValidate")
      return $0 != $1
    }
      .debug("text")

    input.nextBtnTap
      .withLatestFrom(textValidate).filter { $0 }
      .throttle(.milliseconds(500), latest: false)
      .asDriver(onErrorDriveWith: .empty())
      .withLatestFrom(text)
      .flatMapLatest(with: self) { owner, text in
        owner.useCase.updateIntroduce(text)
          .map { text }
          .asDriver { error in
            errorMessage.onNext(error.localizedDescription)
            return .empty()
          }
      }
      .drive(with: self) { owner, text in
        owner.onComplete?()
        owner.userStore.send(action: .introduce(text))
      }.disposed(by: disposeBag)

    return Output(isBtnEnabled: textValidate, 
                  errorMessage: errorMessage.asDriverOnErrorJustEmpty(),
                  initialText: initialText
    )
  }
}
