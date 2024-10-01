////
////  FallingUserCollectionViewCellModel.swift
////  FallingInterface
////
////  Created by SeungMin on 1/11/24.
////
//
//import Foundation
//
//import Core
//import FallingInterface
//import DSKit
//
//

//
//final class FallingUserCollectionViewCellModel: ViewModelType {
//  let userDomain: FallingUser
//  
//  init(userDomain: FallingUser) {
//    self.userDomain = userDomain
//  }
//  
//  var disposeBag: DisposeBag = DisposeBag()
//  
//  struct Input {
//    let timerActiveTrigger: Driver<Bool>
//    let showUserInfoTrigger: Driver<Bool>
//    let rejectButtonTapTrigger: Driver<Void>
//    let likeButtonTapTrigger: Driver<Void>
//    let reportButtonTapTrigger: Driver<Void>
//    let deleteCellTrigger: Driver<Void>
//  }
//  
//  struct Output {
//    let user: Driver<FallingUser>
//    let timeState: Driver<TimeState>
//    let timerActiveAction: Driver<Bool>
//    let timeZero: Driver<AnimationAction>
//    let rejectButtonAction: Driver<Void>
//    let likeButtonAction: Driver<Void>
//    let showUserInfoAction: Driver<Bool>
//    let reportButtonAction: Driver<Void>
//    let deleteCellAction: Driver<Void>
//  }
//  
//  func transform(input: Input) -> Output {
//    let timer = Timer(startTime: 15.0)
//    let time = timer.currentTime.asDriver(onErrorJustReturn: 0.0)
//    let user = Driver.just(userDomain)
//    
//    let timeState = Driver.merge(
//      input.rejectButtonTapTrigger.map { TimeState.none },
//      input.likeButtonTapTrigger.map { TimeState.none },
//      input.deleteCellTrigger.map { TimeState.none },
//      time.map { TimeState(rawValue: $0) }
//    )
//    
//    let timerActiveAction = input.timerActiveTrigger
//      .withLatestFrom(user.map(\.username)) {
//        print($1)
//        return $0
//      }
//      .do { [weak self] value in
//        if !value {
//          timer.pause()
//        } else {
//          timer.start()
//        }
//      }
//    
//    let timeZero = time.filter { $0 == 0.0 }.flatMapLatest { _ in Driver.just(AnimationAction.scroll) }
//    
//    let rejectButtonAction = input.rejectButtonTapTrigger
//      .do { _ in
//        timer.pause()
//      }
//    
//    let likeButtonAction = input.likeButtonTapTrigger
//      .do { _ in
//        timer.pause()
//      }
//    
//    let showUserInfoAction = input.showUserInfoTrigger
//    
//    let reportButtonTapTrigger = input.reportButtonTapTrigger
//    
//    let deleteCellAction = input.deleteCellTrigger
//      .do(onNext: {
//        timer.pause()
//      })
//    
//    return Output(
//      user: user,
//      timeState: timeState,
//      timerActiveAction: timerActiveAction,
//      timeZero: timeZero,
//      rejectButtonAction: rejectButtonAction,
//      likeButtonAction: likeButtonAction,
//      showUserInfoAction: showUserInfoAction,
//      reportButtonAction: reportButtonTapTrigger,
//      deleteCellAction: deleteCellAction
//    )
//  }
//}
