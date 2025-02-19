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
import Domain

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
    let buttonEnabled: Driver<Bool>
  }
  
  func transform(input: Input) -> Output {
    let toast = PublishSubject<String>()
    let imageUploadTrigger = PublishSubject<Void>()
    let blockTrigger = PublishSubject<Void>()
    let fetchedContacts = PublishRelay<[ContactType]>()
    let buttonEnabled = BehaviorRelay<Bool>(value: true)

    input.actionTrigger
      .drive(onNext: { action in
        switch action {
        case .block:
          blockTrigger.onNext(())
        case .skip:
          fetchedContacts.accept([])
        }
      })
      .disposed(by: disposeBag)
    
    input.actionTrigger
      .throttle(.milliseconds(1000), latest: false)
      .do(onNext: { _ in
        buttonEnabled.accept(false)
      })
      .asObservable()
      .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
      .withUnretained(self)
      .flatMap { owner, action -> Observable<[ContactType]> in
        switch action {
        case .block:
          return owner.useCase.block()
            .asObservable()
            .map { contacts in
              toast.onNext("\(contacts.count)개의 연락처를 차단했습니다.")
              return contacts
            }
            .catch { error in
              toast.onNext(error.localizedDescription)
              return .empty()
            }
        case .skip:
          return .just([])
        }
      }
      .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
      .withUnretained(self)
      .flatMap { owner, contacts in
        owner.useCase.signUp(owner.pendingUser, contacts: contacts)
          .asObservable()
          .catch { error in
            toast.onNext(error.localizedDescription)
            return .empty()
          }
      }
      .asDriverOnErrorJustEmpty()
      .drive(with: self) { owner, _ in
        owner.delegate?.invoke(.nextAtHideFriends, owner.pendingUser)
      }
      .disposed(by: disposeBag)
    
    return Output(
      toast: toast.asSignal(onErrorJustReturn: ""),
      buttonEnabled: buttonEnabled.asDriver()
    )
  }
}
