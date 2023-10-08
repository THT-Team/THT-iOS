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
  var disposeBag: DisposeBag = DisposeBag()
  
  struct Input {
    let trigger: Driver<Void>
    let timeOverTrigger: Driver<Void>
  }
  
  struct Output {
    let userList: Driver<[UserDomain]>
    let currentPage: Driver<Int>
  }
  
  init(navigator: MainNavigator) {
    self.navigator = navigator
  }
  
  func transform(input: Input) -> Output {
    let listSubject = BehaviorSubject<[UserSection]>(value: [])
    let currentIndex = BehaviorSubject<Int>(value: 0)
    
    let timeOverTrigger = input.timeOverTrigger
    
    let userSectionList = [UserSection(header: "header",
                                       items: [
                                        UserDTO(userIdx: 0),
                                        UserDTO(userIdx: 1),
                                        UserDTO(userIdx: 2),
                                       ])]
    
    let userList = Driver.just([
      UserDomain(userIdx: 0),
      UserDomain(userIdx: 1),
      UserDomain(userIdx: 2),
    ])

    let currentPage = timeOverTrigger.withLatestFrom(currentIndex.asDriver(onErrorJustReturn: 0)) { _, page in
      currentIndex.onNext(page + 1)
      return page + 1
    }.startWith(0)
    
    return Output(
      userList: userList,
      currentPage: currentPage
    )
  }
}
