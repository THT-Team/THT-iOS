//
//  FallingHomeViewModel.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Core
import FallingInterface

import RxSwift
import RxCocoa
import Foundation

final class FallingHomeViewModel: ViewModelType {
  
  private let fallingUseCase: FallingUseCaseInterface
  
  //  weak var delegate: FallingHomeDelegate?
  
  var disposeBag: DisposeBag = DisposeBag()
  
  struct Input {
    let initialTrigger: Driver<Void>
    let timeOverTrigger: Driver<AnimationAction>
    let cellButtonAction: Driver<FallingCellButtonAction>
    let complaintsButtonTapTrigger: Driver<Void>
    let blockButtonTapTrigger: Driver<Void>
  }
  
  struct Output {
    let userList: Driver<[FallingUser]>
    let nextCardIndexPath: Driver<IndexPath>
    let infoButtonAction: Driver<IndexPath>
    let rejectButtonAction: Driver<IndexPath>
    let complaintsAction: Driver<IndexPath>
    let blockAction: Driver<IndexPath>
  }
  
  init(fallingUseCase: FallingUseCaseInterface) {
    self.fallingUseCase = fallingUseCase
  }
  
  func transform(input: Input) -> Output {
    let currentIndexRelay = BehaviorRelay<Int>(value: 0)
    let timeOverTrigger = input.timeOverTrigger
    let snapshot = BehaviorRelay<[FallingUser]>(value: [])
    
    let usersResponse = input.initialTrigger
      .flatMapLatest { [unowned self] _ in
        self.fallingUseCase.user(alreadySeenUserUUIDList: [], userDailyFallingCourserIdx: 1, size: 100)
          .asDriver(onErrorJustReturn: .init(selectDailyFallingIdx: 0, topicExpirationUnixTime: 0, userInfos: []))
      }
    
    let userList = usersResponse.map {
      snapshot.accept($0.userInfos)
      return $0.userInfos
    }.asDriver()
    
    let updateUserListTrigger = userList.map { _ in
      currentIndexRelay.accept(currentIndexRelay.value)
    }
    
    let updateScrollIndexTrigger = timeOverTrigger.withLatestFrom(currentIndexRelay.asDriver(onErrorJustReturn: 0)) { action, index in
      switch action {
      case .scroll: currentIndexRelay.accept(index + 1)
      case .delete: currentIndexRelay.accept(index + 1)
      }
    }
    
    let nextCardIndexPath = Driver.merge(
      updateUserListTrigger,
      updateScrollIndexTrigger
    ).withLatestFrom(currentIndexRelay.asDriver(onErrorJustReturn: 0)
      .map { IndexPath(row: $0, section: 0) })
    
    let infoButtonAction = input.cellButtonAction
      .compactMap { action -> IndexPath? in
        if case let .info(indexPath) = action {
          return indexPath
        } else { return nil }
      }
    
    let rejectButtonAction = input.cellButtonAction
      .compactMap { action -> IndexPath? in
        if case let .reject(indexPath) = action {
          return indexPath
        }
        return nil
      }
    
    let complaintsAction = input.complaintsButtonTapTrigger.withLatestFrom(currentIndexRelay.asDriver()).map { IndexPath(item: $0, section: 0) }
    
    let blockAction = input.blockButtonTapTrigger
      .withLatestFrom(currentIndexRelay.asDriver()).map { index in
        let indexPath = IndexPath(item: index, section: 0)
//        var mutable = snapshot.value
//        if indexPath.item >= mutable.count {
//          fatalError("index range")
//        }
//        let deleted = mutable[indexPath.item]
//        mutable.remove(at: indexPath.item)
//        snapshot.accept(mutable)
        return indexPath
      }
    
    return Output(
      userList: userList,
      nextCardIndexPath: nextCardIndexPath,
      infoButtonAction: infoButtonAction,
      rejectButtonAction: rejectButtonAction,
      complaintsAction: complaintsAction,
      blockAction: blockAction
    )
  }
}
