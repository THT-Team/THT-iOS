//
//  HeartProfileViewModel.swift
//  Falling
//
//  Created by Kanghos on 2023/09/17.
//

import Foundation

import RxSwift
import RxCocoa
import RxDataSources

final class HeartProfileViewModel: ViewModelType {

  private let service: any HeartAPIType
  private let navigator: HeartProfileNavigatorType
  private let likItem: LikeDTO

  init(service: any HeartAPIType,
       navigator: HeartProfileNavigatorType,
       likeItem: LikeDTO
  ) {
    self.service = service
    self.navigator = navigator
    self.likItem = likeItem
  }

  struct Input {
    let trigger: Driver<Void>
    let rejectTrigger: Driver<Void>
    let chatRoomTrigger: Driver<Void>
  }

  struct Output {
    let userInfo: Driver<HeartUserResponse>
    let photos: Driver<[UserProfilePhoto]>
    let navigate: Driver<Void>
  }

  func transform(input: Input) -> Output {
    let userIDSubject = BehaviorSubject<LikeDTO>(value: self.likItem)

    let userInfo = input.trigger.withLatestFrom(userIDSubject.asDriverOnErrorJustEmpty())
      .flatMapLatest { [unowned self] item in
        service.user(id: item.userUUID)
          .asObservable()
          .asDriverOnErrorJustEmpty()
      }
    let photos = userInfo
      .map { $0.userProfilePhotos }
    let reject = input.rejectTrigger
      .withLatestFrom(userIDSubject.asDriverOnErrorJustEmpty())
      .flatMapLatest { [unowned self] item in
        service.reject(index: item.likeIdx)
          .asObservable()
          .asDriverOnErrorJustEmpty()
      }.do(onNext: { [weak self] in
        self?.navigator.toHeartList()
      }).map { _ in }
    let chatRoom = input.chatRoomTrigger
      .withLatestFrom(userIDSubject.asDriverOnErrorJustEmpty())
      .flatMapLatest { [unowned self] item in
        service.like(id: item.userUUID, topicIndex: item.dailyFallingIdx)
          .asObservable()
          .asDriverOnErrorJustEmpty()
      }.do(onNext: { [weak self] response in
        self?.navigator.toChatRoom(id: "\(response.chatRoomIdx)")
      }).map { _ in }

    let navigate = Driver.of(chatRoom, reject)
      .merge()


    return Output(
      userInfo: userInfo,
      photos: photos,
      navigate: navigate
    )
  }

}
