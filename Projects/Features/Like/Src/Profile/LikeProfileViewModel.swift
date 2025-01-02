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
  private let likItem: Like
  private var disposeBag = DisposeBag()

  var handler: ((LikeCellButtonAction) -> Void)?
  var onDismiss: (() -> Void)?

  public init(likeUseCase: LikeUseCaseInterface, likItem: Like) {
    self.likeUseCase = likeUseCase
    self.likItem = likItem
  }

  public struct Input {
    let trigger: Driver<Void>
    let rejectTrigger: Driver<Void>
    let likeTrigger: Driver<Void>
    let closeTrigger: Driver<Void>
    let reportTrigger: Driver<Void>
  }

  public struct Output {
    let topic: Driver<TopicViewModel>
    let userInfo: Driver<UserInfo>
    let photos: Driver<[UserProfilePhoto]>
  }

  public func transform(input: Input) -> Output {
    let like = Driver.just(self.likItem)

    let userInfo = input.trigger
      .withLatestFrom(like)
      .flatMapLatest(with: self, selector: { owner, like in
        owner.likeUseCase.user(id: like.userUUID)
          .asDriverOnErrorJustEmpty()
      })

    let photos = userInfo
      .map { $0.userProfilePhotos }

    Driver<LikeCellButtonAction>.merge(
      input.rejectTrigger
        .withLatestFrom(like) {
          LikeCellButtonAction.reject($1)
        },
      input.likeTrigger
        .withLatestFrom(like) {
          LikeCellButtonAction.chat($1)
        }
    )
    .drive(with: self, onNext: { owner, action in
      owner.handler?(action)
      owner.onDismiss?()
    })
    .disposed(by: disposeBag)

    input.closeTrigger
      .drive(with: self, onNext: { owner, _ in
        owner.handler?(.cancel)
        owner.onDismiss?()
      })
      .disposed(by: disposeBag)

    return Output(
      topic: like.map { TopicViewModel(topic: $0.topic, issue: $0.issue) },
      userInfo: userInfo,
      photos: photos
    )
  }
}
