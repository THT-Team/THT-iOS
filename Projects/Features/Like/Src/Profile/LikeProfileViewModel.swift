//
//  LikeProfileViewModel.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation

import DSKit
import LikeInterface
import Domain

public final class LikeProfileViewModel: ViewModelType {

  private let likeUseCase: LikeUseCaseInterface
  private let like: Like
  private var disposeBag = DisposeBag()

  var onDismiss: ((LikeCellButtonAction) -> Void)?

  public init(likeUseCase: LikeUseCaseInterface, likItem: Like) {
    self.likeUseCase = likeUseCase
    self.like = likItem
  }

  deinit {
    TFLogger.cycle(name: self)
  }

  public struct Input {
    let trigger: Signal<Void>
    let rejectTrigger: Signal<Void>
    let likeTrigger: Signal<Void>
    let closeTrigger: Signal<Void>
  }

  public struct Output {
    let topic: Driver<TopicViewModel>
    let userInfo: Driver<UserInfo>
  }

  public func transform(input: Input) -> Output {
    let like = Signal.just(self.like)

    let userInfo = input.trigger
      .asObservable()
      .withUnretained(self) { owner, _ in owner }
      .flatMap { owner in
        owner.likeUseCase.user(id: owner.like.userUUID)
          .asObservable()
      }
      .asDriverOnErrorJustEmpty()

    Signal<LikeCellButtonAction>.merge(
      input.rejectTrigger
        .withLatestFrom(like) {
          LikeCellButtonAction.reject($1)
        },
      input.likeTrigger
        .withLatestFrom(like) {
          LikeCellButtonAction.chat($1)
        },
      input.closeTrigger
        .map { LikeCellButtonAction.cancel }
    )
    .emit(with: self, onNext: { owner, action in
      owner.onDismiss?(action)
    })
    .disposed(by: disposeBag)

    return Output(
      topic: Driver.just(self.like).map { TopicViewModel(topic: $0.topic, issue: $0.issue) },
      userInfo: userInfo
    )
  }
}
