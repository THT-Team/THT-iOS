//
//  UserContactViewModel.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/2/24.
//

import Foundation

import Core

import RxSwift
import RxCocoa

import SignUpInterface
import AuthInterface

final class UserContactViewModel: BasePenddingViewModel, ViewModelType {

  enum Action {
    case block
    case skip
  }

  struct Input {
    let actionTrigger: Driver<Action>
  }
  
  struct Output {
    let toast: Signal<String>
  }
  
  func transform(input: Input) -> Output {
    let toast = PublishSubject<String>()
    let nextTrigger = PublishSubject<Void>()
    let blockTrigger = PublishSubject<Void>()
    let fetchedContacts = BehaviorRelay<[ContactType]>(value: [])

    input.actionTrigger
      .drive(onNext: { action in
        switch action {
        case .block:
          blockTrigger.onNext(())
        case .skip:
          nextTrigger.onNext(())
        }
      })
      .disposed(by: disposeBag)
    
    blockTrigger
      .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
      .flatMapLatest { [unowned self] _ in
        self.useCase.block()
          .flatMap { contacts in
            fetchedContacts.accept(contacts)
            toast.onNext("\(contacts.count)개의 연락처를 차단했습니다.")
            return .just(true)
          }
          .catch { error in
            toast.onNext("친구 목록을 불러오는데 실패했습니다. 다시 시도해주세요.")
            return .just(false)
          }
      }
      .asDriver(onErrorJustReturn: false)
      .filter { $0 }
      .map { _ in }
      .delay(.seconds(2))
      .drive(nextTrigger)
      .disposed(by: disposeBag)
    
    nextTrigger
      .withLatestFrom(fetchedContacts)
      .asDriverOnErrorJustEmpty()
      .drive(with: self) { owner, contacts in
        owner.delegate?.invoke(.nextAtHideFriends(contacts), owner.pendingUser)
      }
      .disposed(by: disposeBag)
    
    return Output(
      toast: toast.asSignal(onErrorJustReturn: "")
    )
  }
}
