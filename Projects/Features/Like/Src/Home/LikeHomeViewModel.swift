//
//  LikeViewModel.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/07.
//

import Foundation

import Core
import LikeInterface
import Domain

import RxSwift
import RxCocoa

public typealias LikeTopicSection = (topic: String, [Like])

public final class LikeHomeViewModel: ViewModelType {
  private let likeUseCase: LikeUseCaseInterface

  private var disposeBag: DisposeBag = DisposeBag()

  var onProfile: ((Like, LikeProfileHandler?) -> Void)?
  var onChatRoom: ((String) -> Void)?

  public init(likeUseCase: LikeUseCaseInterface) {
    self.likeUseCase = likeUseCase
    TFLogger.cycle(name: self)
  }

  deinit {
    TFLogger.cycle(name: self)
  }
}

public enum LikeCellButtonAction {
  case reject(Like)
  case chat(Like)
  case profile(Like)
}

extension LikeHomeViewModel {
  typealias CursorInfo = (topicIndex: Int?, likeIndex: Int?)

  public struct Input {
    let trigger: Driver<Void>
    let viewWillAppear: Driver<Void>
    let cellButtonAction: Driver<LikeCellButtonAction>
    let pagingTrigger: Driver<Void>
    let cellUpdateTrigger: Signal<Like>
    let deleteAnimationComplete: Driver<Like>
  }

  public struct Output {
    let likeList: Driver<[LikeTopicSection]>
    let reject: Driver<Like>
    let headerLabel: Driver<(String, String)>
    let isBlurHidden: Signal<Bool>
    let toast: Signal<String>
  }

  public func transform(input: Input) -> Output {
    let currentCursor = BehaviorRelay<CursorInfo>(value: CursorInfo(nil, nil))
    let snapshot = BehaviorRelay<[LikeTopicSection]>(value: [])
    let userAction = PublishSubject<LikeHomeAction>()
    let isBlurHidden = PublishRelay<Bool>()
    let rejectTrigger = PublishRelay<Like>()
    let toastTrigger = PublishRelay<String>()
    let chatTrigger = PublishRelay<Like>()

    let deleteItem = PublishSubject<Like>()
    let changeItem = PublishSubject<Like>()

    input.trigger
      .asObservable()
      .withLatestFrom(currentCursor)
      .withUnretained(self)
      .flatMapLatest { owner, cursor in
        owner.likeUseCase.fetchList(size: 100, lastTopicIndex: cursor.topicIndex, lastLikeIndex: cursor.likeIndex)
          .asObservable()
      }
      .subscribe(with: self) { owner, info in
        let topics = LikeHelper.preprocess(info.likeList)
        snapshot.accept(topics)
        currentCursor.accept(CursorInfo(info.lastFallingTopicIdx, info.lastLikeIdx))
      }
      .disposed(by: disposeBag)

    input.pagingTrigger
      .asObservable()
      .withLatestFrom(currentCursor)
      .withUnretained(self)
      .flatMapLatest { owner, cursor in
        owner.likeUseCase.fetchList(size: 30, lastTopicIndex: cursor.topicIndex, lastLikeIndex: cursor.likeIndex)
          .asObservable()
      }
      .subscribe(with: self, onNext: { owner, info in
        currentCursor.accept(CursorInfo(info.lastFallingTopicIdx, info.lastLikeIdx))
        snapshot.accept(LikeHelper.preprocess(initial: snapshot.value, info.likeList))
      })
      .disposed(by: disposeBag)

    input.viewWillAppear
      .withLatestFrom(snapshot.asDriver())
      .drive()
      .disposed(by: disposeBag)

    input.cellUpdateTrigger
      .emit(to: changeItem)
      .disposed(by: disposeBag)

    input.cellButtonAction
      .map {
        switch $0 {
        case let .chat(like):
          return LikeHomeAction.chat(like)
        case let .profile(like):
          return LikeHomeAction.profile(like)
        case let .reject(like):
          return LikeHomeAction.remove(like)
        }
      }
      .drive(userAction)
      .disposed(by: disposeBag)

    userAction.asDriverOnErrorJustEmpty()
      .drive(with: self, onNext: { owner, action in
        switch action {
        case let .profile(like):
          isBlurHidden.accept(false)
          owner.onProfile?(like) { profileAction in
            isBlurHidden.accept(true)
            switch profileAction {
            case .cancel: break
            case let .chat(id):
              userAction.onNext(.chat(id))
            case let .remove(like):
              userAction.onNext(.remove(like))
            case let .toast(message):
              userAction.onNext(.toast(message))
            }
          }
        case let .chat(like):
          deleteItem.onNext(like)
          chatTrigger.accept(like)
        case let .remove(like):
          rejectTrigger.accept(like)
        case let .toast(message):
          toastTrigger.accept(message)
        }
      })
      .disposed(by: disposeBag)

    chatTrigger
      .withUnretained(self)
      .flatMapLatest { owner, like in
        owner.likeUseCase.like(id: like.userUUID, topicID: "\(like.dailyFallingIdx)")
          .asObservable()
          .map {
            guard $0.isMatching, let chatIdx = $0.chatRoomIdx else {
              throw LikeError.invalid
            }
            return String(chatIdx)
          }
          .catch { error in
            toastTrigger.accept(error.localizedDescription)
            return .empty()
          }
      }.subscribe(with: self) { owner, chatIdx in
        owner.onChatRoom?(chatIdx)
      }.disposed(by: disposeBag)

    input.deleteAnimationComplete
      .flatMap({ [weak self] like -> Driver<Like> in
        guard let self else { return .empty() }
        return self.likeUseCase.reject(index: like.likeIdx)
          .map { _ in like }
          .asDriver { error in
            return .empty()
          }
      })
      .drive(deleteItem)
      .disposed(by: disposeBag)

    deleteItem
      .withLatestFrom(snapshot) { item, snapshot in
        let section: LikeTopicSection? = snapshot.first(where: { (topic, _) in
          topic == item.topic
        }) ?? nil
        guard var (_, items) = section else { return snapshot }
        items.removeAll { $0.identifier == item.identifier }

        let index = snapshot.firstIndex { (topic, _) in
          topic == item.topic
        }
        guard let index else { return snapshot }

        var mutable = snapshot
        mutable[index] = (item.topic, items)

        return mutable
      }
      .asDriverOnErrorJustEmpty()
      .drive(snapshot)
      .disposed(by: disposeBag)

    let headerLabel = snapshot
      .asDriver()
      .map { list in
        let total = list.reduce(0) { $0 + $1.1.count }
        return ("무디 \(total)명", "무디 \(total)명이 나를 좋게 생각해요 :)")
      }

    return Output(
      likeList: snapshot.asDriver(),
      reject: rejectTrigger.asDriverOnErrorJustEmpty(),
      headerLabel: headerLabel,
      isBlurHidden: isBlurHidden.asSignal(),
      toast: toastTrigger.asSignal()
    )
  }
}

public enum LikeHomeAction {
  case toast(String)
  case remove(Like) // API
  case chat(Like) // API
  case profile(Like)
}

public enum LikeProfileAction {
  case toast(String)
  case remove(Like)
  case chat(Like)
  case cancel
}
