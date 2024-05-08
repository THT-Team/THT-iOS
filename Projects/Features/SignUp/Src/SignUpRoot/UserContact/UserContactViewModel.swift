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

final class UserContactViewModel: ViewModelType {
  private let useCase: SignUpUseCaseInterface
  weak var delegate: SignUpCoordinatingActionDelegate?
  private let disposeBag = DisposeBag()
  private let contactsTrigger = PublishSubject<[UserFriendContactReq.Contact]>()
  
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
  
  init(useCase: SignUpUseCaseInterface) {
    self.useCase = useCase
  }
  
  func transform(input: Input) -> Output {
    let toast = PublishSubject<String>()
    let nextTrigger = PublishSubject<Void>()
    let blockTrigger = PublishSubject<Void>()
    let timerTrigger = PublishSubject<Void>()
    
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
      .flatMapLatest { [unowned self] _ in
        self.useCase.block(contacts: <#T##UserFriendContactReq#>)
      }
    
    contactsTrigger
      .map { UserFriendContactReq(contacts: $0) }
      .flatMapLatest { [unowned self] request in
        self.useCase.block(contacts: request)
          .map { count in
            timerTrigger.onNext(())
            return "저장된 연락처 \(count)개를 모두 차단했습니다."
          }
          .catch { error in
            return .just(error.localizedDescription)
          }
      }
      .bind(to: toast)
      .disposed(by: disposeBag)
    
    timerTrigger
      .delay(.seconds(3), scheduler: MainScheduler.instance)
      .bind(to: nextTrigger)
      .disposed(by: disposeBag)
    
    nextTrigger
      .asDriverOnErrorJustEmpty()
      .drive(with: self) { owner, _ in
        owner.delegate?.invoke(.nextAtHideFriends)
      }
      .disposed(by: disposeBag)
    
    return Output(
      toast: toast.asSignal(onErrorJustReturn: "")
    )
  }
}


extension UserContactViewModel: UserContactListener {
  func picker(didFinishPicking contacts: [UserFriendContactReq.Contact]) {
    print(contacts)
    self.contactsTrigger.onNext(contacts)
  }
}
