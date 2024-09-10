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

final class LikeHomeViewModel: ViewModelType {
  private let likeUseCase: LikeUseCaseInterface

  weak var delegate: LikeCoordinatorActionDelegate?

  private var disposeBag: DisposeBag = DisposeBag()
  private let signal = PublishSubject<Action>()

  init(likeUseCase: LikeUseCaseInterface) {
    self.likeUseCase = likeUseCase
    TFLogger.cycle(name: self)
  }

  deinit {
    TFLogger.cycle(name: self)
  }
}

enum LikeCellButtonAction {
  case reject(IndexPath)
  case chat(IndexPath)
  case profile(IndexPath)
}

extension LikeHomeViewModel {
  enum Action {
    case removeItem(Like)
  }

  struct Input {
    let trigger: Driver<Void>
    let cellButtonAction: Driver<LikeCellButtonAction>
    let pagingTrigger: Driver<Void>
  }

  struct Output {
    let likeList: Driver<[Like]>
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
    let navigateAction = PublishSubject<LikeCoordinatorAction>()

		
    let refresh = input.trigger
      .flatMapLatest { [unowned self] _ in
				// FIXME: Error Handling
        self.likeUseCase.fetchList(size: 100, lastTopicIndex: nil, lastLikeIndex: nil)
          .flatMap { info in
            currentCursor.accept(CursorInfo(info.lastLikeIdx, info.lastFallingTopicIdx))
						let likeList = info.likeList
            snapshot.accept(likeList)
            return Observable.just(likeList)
          }
          .asDriverOnErrorJustEmpty()
      }

    let newPage = input.pagingTrigger
      .asObservable()
      .withLatestFrom(currentCursor)
      .withUnretained(self)
      .flatMapLatest { owner, cursorInfo in
        owner.likeUseCase.fetchList(size: 100, lastTopicIndex: nil, lastLikeIndex: nil)
          .map {
            currentCursor.accept(CursorInfo($0.lastLikeIdx, $0.lastFallingTopicIdx))
            var mutable = snapshot.value
            mutable.append(contentsOf: $0.likeList )
            snapshot.accept(mutable)
            return mutable
          }
      }
      .asDriverOnErrorJustEmpty()

    let rejectFromSignal = self.signal
      .compactMap { action -> Like? in
        if case let .removeItem(like) = action {
          return like
        }
        return nil
      }.map { like in
        var mutable = snapshot.value
        mutable.removeAll { $0 == like }
        snapshot.accept(mutable)
        return like
      }.asDriverOnErrorJustEmpty()


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

    input.cellButtonAction
      .compactMap { action -> IndexPath? in
        if case let .chat(indexPath) = action {
          return indexPath
        }
        return nil
      }
      .withLatestFrom(snapshot.asDriverOnErrorJustEmpty()) {
        indexPath, dataSource in
        dataSource[indexPath.item].userUUID
      }
      .map { .pushChatRoom(id: $0) }
      .drive(navigateAction)
      .disposed(by: disposeBag)

    input.cellButtonAction
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
      .drive(with: self, onNext: { owner, like in
        navigateAction.onNext(.presentProfile(like: like, listener: owner))
      } )
      .disposed(by: disposeBag)

    navigateAction
      .subscribe(onNext: { [weak self] action in
        self?.delegate?.invoke(action)
      })
      .disposed(by: disposeBag)

    return Output(
			likeList: refresh,
      reject: Driver.merge(reject, rejectFromSignal),
      pagingList: newPage
    )
  }
}

extension LikeHomeViewModel: LikeProfileListener {

  func likeProfileDidTapChat(_ like: Like) {
    self.delegate?.invoke(.pushChatRoom(id: like.userUUID))
  }

  func likeProfileDidTapReject(_ like: Like) {
    self.signal.onNext(.removeItem(like))
    //    self.delegate?.invoke(.dismissProfile)
  }
}
