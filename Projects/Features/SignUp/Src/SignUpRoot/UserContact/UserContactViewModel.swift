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
        self.useCase.block()
          .flatMap { count in
            toast.onNext("\(count)개의 연락처를 차단했습니다.")
            return .just(true)
          }
          .catch { error in
            toast.onNext("친구 목록을 불러오는데 실패했습니다. 다시 시도해주세요.")
            return .just(false)
          }
      }.asDriver(onErrorJustReturn: false)
      .filter { $0 }
      .map { _ in }
      .delay(.seconds(2))
      .drive(nextTrigger)
      .disposed(by: disposeBag)
    // TODO: Block 성공하면 toast 띄우고, 2초 뒤 next, 실패하면 toast 띄우고, next 안함
    
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
