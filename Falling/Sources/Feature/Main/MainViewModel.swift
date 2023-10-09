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
    let trigger: Driver<Void>
    let timeOverTrigger: Driver<Void>
  }
  
  struct Output {
    let userList: Driver<[UserDomain]>
    let currentPage: Driver<Int>
  }
  
  init(navigator: MainNavigator, service: FallingAPI) {
    self.navigator = navigator
    self.service = service
  }
  
  func transform(input: Input) -> Output {
    let listSubject = BehaviorSubject<[UserSection]>(value: [])
    let currentIndex = BehaviorSubject<Int>(value: 0)
    let timeOverTrigger = input.timeOverTrigger

    let dailyUsers = input.trigger
      .flatMapLatest { [unowned self] in
        self.service.user(DailyFallingUserRequest(alreadySeenUserUUIDList: [], userDailyFallingCourserIdx: 1, size: 100))
          .asDriver(onErrorJustReturn: .init(selectDailyFallingIdx: 0, topicExpirationUnixTime: 0, userInfos: []))
      }
    let users = dailyUsers.map { $0.userInfos.map { $0.toDomain() } }
      .flatMap { list in
        currentIndex.onNext(0)
        return Driver.just(list)
      }
    let initialPage = users.map { _ in
      currentIndex.onNext(0)
    }
    let nextPage = timeOverTrigger.withLatestFrom(currentIndex.asDriver(onErrorJustReturn: 0)) { _, page in
        currentIndex.onNext(page + 1)
      }

    let currentPage = Driver.merge(initialPage, nextPage).withLatestFrom(currentIndex.asDriver(onErrorJustReturn: 0))
    
    return Output(
      userList: users,
      currentPage: currentPage
    )
  }
}
