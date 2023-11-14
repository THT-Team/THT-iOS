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
  }
  
  struct Output {
    let userList: Driver<[UserDomain]>
    let userCardScrollIndex: Driver<Int>
  }
  
  init(navigator: MainNavigator, service: FallingAPI) {
    self.navigator = navigator
    self.service = service
  }
  
  func transform(input: Input) -> Output {
    let currentIndexRelay = BehaviorRelay<Int>(value: 0)
    let timeOverTrigger = input.timeOverTrigger
    
    let usersResponse = input.initialTrigger
      .flatMapLatest { [unowned self] _ in
        self.service.user(DailyFallingUserRequest(alreadySeenUserUUIDList: [], userDailyFallingCourserIdx: 1, size: 100))
          .asDriver(onErrorJustReturn: .init(selectDailyFallingIdx: 0, topicExpirationUnixTime: 0, userInfos: []))
      }
    
    let userList = usersResponse.map { $0.userInfos.map { $0.toDomain() } }
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
    
    return Output(
      userList: userList,
      userCardScrollIndex: userCardScrollIndex)
  }
}
