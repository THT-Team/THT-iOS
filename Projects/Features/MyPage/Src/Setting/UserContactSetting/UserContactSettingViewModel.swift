//
//  UserContactSettingViewModel.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/10/24.
//

import Foundation

import Core

import RxSwift
import RxCocoa

import MyPageInterface

final class UserContactSettingViewModel: ViewModelType {
  private var disposeBag = DisposeBag()
  private let useCase: MyPageUseCaseInterface
  weak var delegate: MySettingCoordinatingActionDelegate?

  init(useCase: MyPageUseCaseInterface) {
    self.useCase = useCase
  }

  struct Input {
    let tap: Driver<Void>
  }

  struct Output {
    let toast: Driver<String>
  }

  func transform(input: Input) -> Output {
    let toast = PublishSubject<String>()

    Observable.just(())
      .delay(.seconds(1), scheduler: MainScheduler.instance)
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.useCase.fetchUserContacts()
          .catchAndReturn(0)
          .asObservable()
      }
      .asDriverOnErrorJustEmpty()
      .drive(onNext: { count in
        toast.onNext("\(count)")
      })
      .disposed(by: disposeBag)
//
//
    input.tap
      .asObservable()
      .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.useCase.updateUserContact()
          .catchAndReturn(0)
      }
      .map { "\($0)개의 연락처를 차단했습니다." }
      .debug("toast")
      .asDriverOnErrorJustEmpty()
      .drive(toast)
      .disposed(by: disposeBag)



    return Output(toast: toast.asDriverOnErrorJustEmpty())
  }
}
