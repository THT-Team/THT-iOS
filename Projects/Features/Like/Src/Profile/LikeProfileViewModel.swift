//
//  LikeProfileViewModel.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation

import Core
import LikeInterface
import DSKit

import RxSwift
import RxCocoa

protocol LikeProfileDelegate: AnyObject {
  func selectNextTime(userUUID: String)
  func selectLike(userUUID: String)
  func toList()
}

final class LikeProfileViewModel: ViewModelType {

  private let likeUseCase: LikeUseCaseInterface
  private let likItem: Like
  private var disposeBag = DisposeBag()

  weak var delegate: LikeProfileDelegate?


  init(likeUseCase: LikeUseCaseInterface, likItem: Like) {
    self.likeUseCase = likeUseCase
    self.likItem = likItem
  }

  struct Input {
    let trigger: Driver<Void>
    let rejectTrigger: Driver<Void>
    let likeTrigger: Driver<Void>
    let closeTrigger: Driver<Void>
    let reportTrigger: Driver<Void>
  }

  struct Output {
    let topic: Driver<TopicViewModel>
    let userInfo: Driver<LikeUserInfo>
    let photos: Driver<[UserProfilePhoto]>
  }

  func transform(input: Input) -> Output {

    let topic = Driver.just(self.likItem).map {
      TopicViewModel(topic: $0.topic, issue: $0.issue)
    }
    let userIDSubject = BehaviorSubject<Like>(value: self.likItem)
    let userInfo = input.trigger
      .asObservable()
      .withLatestFrom(userIDSubject)
      .flatMapLatest(weak: self, selector: { owner, item in
        owner.likeUseCase.user(id: item.userUUID)
      })
      .asDriverOnErrorJustEmpty()


    let photos = userInfo
      .map { $0.userProfilePhotos }

    input.rejectTrigger
      .withLatestFrom(userIDSubject.asDriverOnErrorJustEmpty())
      .map { $0.likeIdx }.map(String.init)
      .drive(with: self, onNext: { owner, uuid in
        owner.delegate?.selectNextTime(userUUID: uuid)
      })
      .disposed(by: disposeBag)

    input.likeTrigger
      .withLatestFrom(userIDSubject.asDriver(onErrorDriveWith: .empty()))
    .map { $0.likeIdx }.map(String.init)
    .drive(with: self, onNext: { owner, id in
      owner.delegate?.selectLike(userUUID: id)
    })
    .disposed(by: disposeBag)

    input.closeTrigger
      .drive(with: self, onNext: { owner, _ in
        owner.delegate?.toList()
      })
      .disposed(by: disposeBag)

    return Output(
      topic: topic,
      userInfo: userInfo,
      photos: photos
    )
  }
}
