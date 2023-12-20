//
//  LikeViewModel.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/07.
//

import Foundation

import Core
import LikeInterface

import RxSwift
import RxCocoa

protocol LikeHomeDelegate: AnyObject {
  func toProfile(like: Like)
  func toChatRoom(userID: String)
}

final class LikeHomeViewModel: ViewModelType {
  private let likeUseCase: LikeUseCaseInterface
  
  weak var delegate: LikeHomeDelegate?

  var disposeBag: DisposeBag = DisposeBag()

  init(likeUseCase: LikeUseCaseInterface) {
    self.likeUseCase = likeUseCase
    TFLogger.cycle(name: self)
  }

  deinit {
    TFLogger.cycle(name: self)
  }
}

extension LikeHomeViewModel {
  struct Input {
    let trigger: Driver<Void>
    let cellButtonAction: Driver<LikeCellButtonAction>
    let pagingTrigger: Driver<Void>
  }

  struct Output {
    let heartList: Driver<[Like]>
    let chatRoom: Driver<Void>
    let profile: Driver<Void>
    let reject: Driver<Like>
    let pagingList: Driver<[Like]>
  }

  typealias CursorInfo = (lastTopicIndex: Int?, lastLikeIndex: Int?)
  enum EditingCommand {
    case delete(IndexPath)
    case append(item: Like, section: Int)
  }

  func transform(input: Input) -> Output {
    let currentCursor = BehaviorRelay<CursorInfo>(value: CursorInfo(nil, nil))
    let snapshot = BehaviorRelay<[Like]>(value: [])

    let refresh = input.trigger
      .asObservable()
      .flatMapLatest(weak: self, selector: { owner, _ in
        owner.likeUseCase.fetchList(size: 100, lastTopicIndex: nil, lastLikeIndex: nil)
        .map {
          currentCursor.accept(CursorInfo($0.lastLikeIdx, $0.lastFallingTopicIdx))
          let initial = $0.likeList
          snapshot.accept(initial)
          return initial
        }
      })
      .asDriverOnErrorJustEmpty()

    let newPage = input.pagingTrigger
      .asObservable()
      .withLatestFrom(currentCursor)
      .flatMapLatest(weak: self, selector: { owner, cursorInfo in
        owner.likeUseCase.fetchList(size: 100, lastTopicIndex: nil, lastLikeIndex: nil)
        .map {
          currentCursor.accept(CursorInfo($0.lastLikeIdx, $0.lastFallingTopicIdx))
          var mutable = snapshot.value
          mutable.append(contentsOf: $0.likeList )
          snapshot.accept(mutable)
          return mutable
        }
      })
      .asDriverOnErrorJustEmpty()

    let reject = input.cellButtonAction
      .compactMap { action -> IndexPath? in
        if case let .reject(indexPath) = action {
          return indexPath
        }
        return nil
      }.compactMap { indexPath -> Like? in
        var mutable = snapshot.value
        if indexPath.item >= mutable.count {
          fatalError("index range")
        }
        let deleted = mutable[indexPath.item]
        mutable.remove(at: indexPath.item)
        snapshot.accept(mutable)
        return deleted
      }

    let chatRoom = input.cellButtonAction
      .compactMap { action -> IndexPath? in
        if case let .chat(indexPath) = action {
          return indexPath
        }
        return nil
      }
      .withLatestFrom(snapshot.asDriverOnErrorJustEmpty()) {
        indexPath, dataSource in
        dataSource[indexPath.item]
      }
      .do(onNext: { [weak self] item in
        self?.delegate?.toChatRoom(userID: item.userUUID)
      })
      .map { _ in }

    let profile = input.cellButtonAction
      .compactMap { action -> IndexPath? in
        if case let .profile(indexPath) = action {
          return indexPath
        }
        return nil
      }
      .withLatestFrom(snapshot.asDriverOnErrorJustEmpty()) {
        indexPath, dataSource in
        dataSource[indexPath.item]
      }
      .do(onNext: { [weak self] item in
        self?.delegate?.toProfile(like: item)
      }).map { _ in }

    return Output(
      heartList: refresh,
      chatRoom: chatRoom,
      profile: profile,
      reject: reject,
      pagingList: newPage
    )
  }
}
