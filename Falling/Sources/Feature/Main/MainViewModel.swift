//
//  MainViewModel.swift
//  Falling
//
//  Created by SeungMin on 2023/08/15.
//
import Foundation

import RxSwift
import RxCocoa

final class MainViewModel: ViewModelType {
  
  private let navigator: MainNavigator
  private let service: FallingAPI
  var disposeBag: DisposeBag = DisposeBag()
  
  struct Input {
    let initialTrigger: Driver<Void>
    let timeOverTrigger: Driver<Void>
    let timerActiveTrigger: Driver<Bool>
  }
  
  struct Output {
    let userList: Driver<[UserDomain]>
    let userCardScrollIndex: Driver<Int>
    let timerActiveTrigger: Driver<Bool>
  }
  
  init(navigator: MainNavigator, service: FallingAPI) {
    self.navigator = navigator
    self.service = service
  }
  
  func transform(input: Input) -> Output {
    let currentIndexRelay = BehaviorRelay<Int>(value: 0)
    let timeOverTrigger = input.timeOverTrigger
//    let timerActiveRelay = BehaviorRelay<Bool>(value: true)
    
    let userSequence = input.initialTrigger
      .flatMapLatest { [unowned self] _ in
        self.service.user(DailyFallingUserRequest(alreadySeenUserUUIDList: [], userDailyFallingCourserIdx: 1, size: 100))
          .asDriver(onErrorJustReturn: .init(selectDailyFallingIdx: 0, topicExpirationUnixTime: 0, userInfos: []))
      }
    
    let userList = userSequence.map { $0.userInfos.map { $0.toDomain() } }
      .flatMap { list in
        return Driver.just(list)
      }
    
    let userListObservable = userList.map { _ in
      currentIndexRelay.accept(currentIndexRelay.value)
    }
    
    let nextScrollIndex = timeOverTrigger.withLatestFrom(currentIndexRelay.asDriver(onErrorJustReturn: 0)) { _, index in
      currentIndexRelay.accept(index + 1)
    }
    
    let userCardScrollIndex = Driver.merge(userListObservable, nextScrollIndex).withLatestFrom(currentIndexRelay.asDriver(onErrorJustReturn: 0))
    
    let timerActiveTrigger = input.timerActiveTrigger
//      .flatMapLatest { value in
//        timerActiveRelay.accept(!timerActiveRelay.value)
//        return Driver.just(value)
//      }
//
    
        
    return Output(
      userList: userList,
      userCardScrollIndex: userCardScrollIndex,
      timerActiveTrigger: timerActiveTrigger
    )
  }
}
