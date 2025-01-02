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

public typealias LikeHandler = ((LikeCellButtonAction) -> Void)
public typealias LikeTopicSection = (topic: String, [Like])

public final class LikeHomeViewModel: ViewModelType {
  private let likeUseCase: LikeUseCaseInterface

  private var disposeBag: DisposeBag = DisposeBag()

  var onProfile: ((Like,LikeHandler?) -> Void)?
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
  case cancel
}

extension LikeHomeViewModel {
  typealias CursorInfo = (topicIndex: Int?, likeIndex: Int?)

  public struct Input {
    let trigger: Driver<Void>
    let cellButtonAction: Driver<LikeCellButtonAction>
    let pagingTrigger: Driver<Void>
    let deleteAnimationComplete: Driver<Like>
  }

  public struct Output {
    let likeList: Driver<[LikeTopicSection]>
    let reject: Driver<Like>
    let headerLabel: Driver<(String, String)>
    let blurFlag: Signal<Bool>
  }

  public func transform(input: Input) -> Output {
    let currentCursor = BehaviorRelay<CursorInfo>(value: CursorInfo(nil, nil))
    let snapshot = BehaviorRelay<[LikeTopicSection]>(value: [])
    let userAction = PublishSubject<LikeCellButtonAction>()
    let blurTrigger = PublishRelay<Bool>()

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

    input.cellButtonAction
      .drive(userAction)
      .disposed(by: disposeBag)

    userAction.asDriverOnErrorJustEmpty()
      .drive(with: self, onNext: { owner, action in
        switch action {
        case let .profile(like):
          blurTrigger.accept(true)
          owner.onProfile?(like) { userAction.onNext($0) }
        case let .chat(like):
          blurTrigger.accept(false)
          owner.onChatRoom?(like.userUUID)
        case .reject:
          blurTrigger.accept(false)
          break
        case .cancel:
          blurTrigger.accept(false)
        }
      })
      .disposed(by: disposeBag)

    let reject = userAction
      .compactMap { action -> Like? in
      if case let .reject(like) = action {
        return like
      }
      return nil
      }
      .asDriverOnErrorJustEmpty()

    input.deleteAnimationComplete
      .withLatestFrom(snapshot.asDriver()) { item, snapshot in
        let section: LikeTopicSection? = snapshot.first(where: { (topic, _) in
          topic == item.topic
        }) ?? nil
        guard var (topic, items) = section else { return snapshot }
        items.removeAll { $0.identifier == item.identifier }

        let index = snapshot.firstIndex { (topic, _) in
          topic == item.topic
        }
        guard let index else { return snapshot }

        var mutable = snapshot
        mutable[index] = (topic, items)

        return mutable
      }
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
      reject: reject,
      headerLabel: headerLabel,
      blurFlag: blurTrigger.asSignal()
    )
  }
}

struct LikeHelper {
  static func preprocess(initial: [LikeTopicSection] = [], _ raws: [Like]) -> [LikeTopicSection] {
    var topics: [String] = initial.map { $0.topic }
    var sections: [String: [Like]] = [:]
    initial.forEach { (key, items) in
      sections[key] = items
    }

    raws.forEach { item in
      if sections[item.topic] == nil {
        topics.append(item.topic)
      }
      sections[item.topic, default: []].append(item)
    }

    return topics
      .compactMap { topic -> LikeTopicSection? in
        guard let value = sections[topic] else { return nil }
        return (topic, value)
    }
  }
}

struct OrderedDictionary<Key: Hashable, Value> {
  private var keys: [Key] = []
  private var values: [Key: Value] = [:]

  func values(for key: Key) -> Value? {
    return values[key]
  }

  var orderedKeys: [Key] {
    keys
  }

  mutating func updateValue(_ value: Value, forKey key: Key) {
         if values[key] == nil {
             keys.append(key) // Add key if it's new
         }
         values[key] = value
  }

  func orderedPairs() -> [(Key, Value)] {
    keys.compactMap { key -> (Key, Value)? in
      guard let value = values[key] else { return nil }
      return (key, value)
    }
  }
}
