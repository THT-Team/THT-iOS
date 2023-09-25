//
//  HeartListViewModel.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import Foundation

import RxSwift
import RxCocoa

final class HeartListViewModel: ViewModelType {
  enum EditingCommand {
    case delete(IndexPath)
    case append(item: LikeDTO, section: Int)
  }

  struct Input {
    let trigger: Driver<Void>
    let cellButtonAction: Driver<LikeCellButtonAction>
  }

  struct Output {
    let heartList: Driver<[LikeSection]>
    let chatRoom: Driver<Void>
    let profile: Driver<Void>
  }

  private let navigator: HeartNavigator
  private let service: HeartAPI

  init(navigator: HeartNavigator, service: HeartAPI) {
    self.navigator = navigator
    self.service = service
  }

  var disposeBag: DisposeBag = DisposeBag()

  func transform(input: Input) -> Output {
    let listSubject = PublishSubject<[LikeSection]>()

    let refreshResponse = input.trigger
      .flatMapLatest { [unowned self] _ in
        service.list(
          pagingRequest: HeartListRequest()
        )
        .asObservable()
        .asDriverOnErrorJustEmpty()
      }

    let newList = refreshResponse.map { $0.likeList }
      .map(HeartSectionMapper.map)
      .do(onNext: { listSubject.onNext($0) })

    let cellAction = input.cellButtonAction

    let rejectItem = cellAction
      .map { action -> IndexPath? in
      if case let .reject(indexPath) = action {
        return indexPath
      }
      return nil
    }.compactMap { $0 }

    let deleteCommand = rejectItem.withLatestFrom(listSubject.asDriverOnErrorJustEmpty()) { indexPath, sections -> [LikeSection] in
      var original = sections
      original[indexPath.section].items.remove(at: indexPath.item)
      return original
    }.do(onNext: { listSubject.onNext($0) })

    let outputList = Driver.of(newList, deleteCommand)
      .merge()
      .withLatestFrom(listSubject.asDriverOnErrorJustEmpty())

    let rejectResponse = rejectItem
      .debug("reject Trigger")
      .withLatestFrom(listSubject.asDriverOnErrorJustEmpty()) {
        indexPath, dataSource -> LikeDTO in
        dataSource[indexPath.section].items[indexPath.item]
      }
      .flatMapLatest { [unowned self] model in
        service.reject(index: model.likeIdx)
          .asObservable()
          .asDriverOnErrorJustEmpty()
      }
    let profile = cellAction
      .map { action -> IndexPath? in
      if case let .profile(indexPath) = action {
        return indexPath
      }
      return nil
      }.compactMap { $0 }
      .withLatestFrom(listSubject.asDriverOnErrorJustEmpty()) {
        indexPath, dataSource in
        dataSource[indexPath.section].items[indexPath.item]
      }.do(onNext: { [weak self] item in
        self?.navigator.toProfile(item: item)
      })


    let chatRoomSubject = cellAction
      .map { action -> IndexPath? in
      if case let .chat(indexPath) = action {
        return indexPath
      }
      return nil
    }
      .compactMap { $0 }
      .debug("chat Trigger")
      .withLatestFrom(listSubject.asDriver(onErrorDriveWith: .empty())) { indexPath, dataSource -> LikeDTO in
        let section = dataSource[indexPath.section]
        let item = section.items[indexPath.row]
        return item
    }.flatMapLatest { [unowned self] item in
      service.like(id: item.userUUID, topicIndex: 1)
        .asDriver(onErrorDriveWith: .empty())
    }.filter { $0.isMatching }
      .map { String($0.chatRoomIdx) }
      .do { [weak self] roomIndex in
        self?.navigator.toChatRoom(id: roomIndex)
      }.map { _ in }

    return Output(
      heartList: outputList,
      chatRoom: chatRoomSubject.asDriver(),
      profile: profile.map { _ in }
    )

  }
}
