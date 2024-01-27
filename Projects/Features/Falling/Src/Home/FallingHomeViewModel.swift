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
    let timeOverTrigger: Driver<Void>
  }

  struct Output {
    let userList: Driver<[FallingUser]>
    let userCardScrollIndex: Driver<Int>
    let nextCardIndex: Driver<IndexPath>
  }

  init(fallingUseCase: FallingUseCaseInterface) {
    self.fallingUseCase = fallingUseCase
  }

  func transform(input: Input) -> Output {
    let currentIndexRelay = BehaviorRelay<Int>(value: 0)
    let timeOverTrigger = input.timeOverTrigger

    let usersResponse = input.initialTrigger
      .flatMapLatest { [unowned self] _ in
        self.fallingUseCase.user(alreadySeenUserUUIDList: [], userDailyFallingCourserIdx: 1, size: 100)
          .asDriver(onErrorJustReturn: .init(selectDailyFallingIdx: 0, topicExpirationUnixTime: 0, userInfos: []))
      }

    let userList = usersResponse.map { $0.userInfos }.asDriver()

    let userCount = userList.map { $0.count }

    let userListObservable = userList.map { _ in
      currentIndexRelay.accept(currentIndexRelay.value)
    }

    let nextScrollIndex = timeOverTrigger.withLatestFrom(currentIndexRelay.asDriver(onErrorJustReturn: 0)) { _, index in
      currentIndexRelay.accept(index + 1)
    }

    let userCardScrollIndex = Driver.merge(userListObservable, nextScrollIndex).withLatestFrom(userCount) { _, count in
      let currentIndex = currentIndexRelay.value
      return currentIndex >= count ? count - 1 : currentIndex
    }

    let nextCardIndex = userCardScrollIndex
      .filter { $0 != 0 }
      .map { IndexPath(row: $0, section: 0) }

    return Output(
      userList: userList,
      userCardScrollIndex: userCardScrollIndex,
      nextCardIndex: nextCardIndex
    )
  }
}
