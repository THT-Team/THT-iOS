//
//  MainViewModel.swift
//  Falling
//
//  Created by SeungMin on 2023/08/15.
//

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
    let userList: Driver<[UserSection]>
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
    
    let userList = Observable.just(userSectionList).asDriver(onErrorJustReturn: [])
    
    let currentPage = currentIndex.map{ $0 }.asDriver(onErrorJustReturn: 0)
    
    timeOverTrigger.do(onNext: {
      do {
        currentIndex.onNext(try currentIndex.value() + 1)
      } catch { }
    }).drive()
      .disposed(by: disposeBag)
    
    return Output(
      userList: userList,
      currentPage: currentPage
    )
  }
}
