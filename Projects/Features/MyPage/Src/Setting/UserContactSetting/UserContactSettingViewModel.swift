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

public final class UserContactSettingViewModel: ViewModelType {
  private var disposeBag = DisposeBag()
  private let useCase: MyPageUseCaseInterface
  weak var delegate: MySettingCoordinatingActionDelegate?

  init(useCase: MyPageUseCaseInterface) {
    self.useCase = useCase
  }

  public struct Input {
    let viewDidAppear: Driver<Void>
    let tap: Driver<Void>
  }

  public struct Output {
    let toast: Driver<String>
    let fetchedContactCount: Driver<Int>
  }

  public func transform(input: Input) -> Output {
    let toast = PublishSubject<String>()
    let fetchedContactCount = PublishSubject<Int>()

    input.viewDidAppear
      .flatMapLatest(with: self) { owner, _ in
        owner.useCase.fetchUserContacts()
          .asDriver(onErrorRecover: { error in
            toast.onNext(error.localizedDescription)
            return .empty()
          })
      }
      .drive(fetchedContactCount)
      .disposed(by: disposeBag)

    input.tap
      .asObservable()
      .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.useCase.updateUserContact()
          .catchAndReturn(0)
      }
      .flatMap({ count -> Observable<Int> in
        fetchedContactCount.onNext(count)
        return .just(count)
      })
      .map { "\($0)개의 연락처를 차단했습니다." }
      .bind(to: toast)
      .disposed(by: disposeBag)



    return Output(
      toast: toast.asDriverOnErrorJustEmpty(),
      fetchedContactCount: fetchedContactCount.asDriverOnErrorJustEmpty()
    )
  }
}
