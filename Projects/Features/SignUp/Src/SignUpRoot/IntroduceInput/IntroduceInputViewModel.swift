//
//  IntroduceInputViewModel.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/24.
//

import Foundation

import Core

import RxCocoa
import RxSwift
import SignUpInterface

final class IntroduceInputViewModel: ViewModelType {
  private let userInfoUseCase: UserInfoUseCaseInterface

  struct Input {
    let nextBtn: Driver<Void>
    let introduceText: Driver<String>
  }

  struct Output {
    let initialValue: Driver<String?>
    let isEnableNextBtn: Driver<Bool>
  }

  weak var delegate: SignUpCoordinatingActionDelegate?
  private let disposeBag = DisposeBag()

  init(userInfoUseCase: UserInfoUseCaseInterface) {
    self.userInfoUseCase = userInfoUseCase
  }

  func transform(input: Input) -> Output {
    let userinfo = Driver.just(())
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.userInfoUseCase.fetchUserInfo()
          .catchAndReturn(UserInfo(phoneNumber: ""))
          .asObservable()
      }
      .asDriverOnErrorJustEmpty()

    let local = userinfo.map { $0.introduction }

    let isEnableNextBtn = input.introduceText
      .map { !$0.isEmpty && $0.count < 201 }
    
    input.nextBtn
      .withLatestFrom(isEnableNextBtn)
      .filter{ $0 }
      .withLatestFrom(input.introduceText)
      .withLatestFrom(userinfo) { text, userinfo in
        var mutable = userinfo
        mutable.introduction = text
        return mutable
      }
      .drive(with: self, onNext: { owner, userinfo in
        owner.userInfoUseCase.updateUserInfo(userInfo: userinfo)
        owner.delegate?.invoke(.nextAtIntroduce)
      })
      .disposed(by: disposeBag)


    return Output(
      initialValue: local,
      isEnableNextBtn: isEnableNextBtn
    )
  }
}
