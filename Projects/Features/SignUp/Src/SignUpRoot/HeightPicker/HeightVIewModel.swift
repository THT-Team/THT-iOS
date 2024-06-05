//
//  HeightVIewModel.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import Foundation

import Core
import SignUpInterface

import RxSwift
import RxCocoa

final class HeightPickerViewModel: ViewModelType {
  weak var delegate: SignUpCoordinatingActionDelegate?

  struct Input {
    var pickerLabelTap: Driver<Void>
    var nextBtnTap: Driver<Void>
  }

  struct Output {
    var height: Driver<String>
    var isNextBtnEnabled: Driver<Bool>
  }

  private var disposeBag = DisposeBag()
  private let userInfoUseCase: UserInfoUseCaseInterface

  private var selectedHeight = BehaviorRelay<Int>(value: 145)

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

    userinfo
      .compactMap { $0.tall }
      .drive(selectedHeight)
      .disposed(by: disposeBag)

    let height = self.selectedHeight
      .asDriver()

    let nextBtnisEnabled = height
      .map { _ in return true }

    input.pickerLabelTap
      .withLatestFrom(height)
      .drive(with: self) { owner, height in
        owner.delegate?.invoke(.heightLabelTap(height, listener: owner))
      }.disposed(by: disposeBag)

    input.nextBtnTap
      .withLatestFrom(nextBtnisEnabled)
      .filter { $0 }
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(height)
      .withLatestFrom(userinfo) { height, userinfo in
        var mutable = userinfo
        mutable.tall = height
        return mutable
      }
      .drive(with: self) { owner, userinfo in
        owner.userInfoUseCase.updateUserInfo(userInfo: userinfo)
        owner.delegate?.invoke(.nextAtHeight)
      }.disposed(by: disposeBag)

    return Output(
      height: height.map { String($0) + " cm" },
      isNextBtnEnabled: nextBtnisEnabled
    )
  }
}

extension HeightPickerViewModel: BottomSheetListener {
  func sendData(item: BottomSheetValueType) {
    if case let .text(text) = item {
      self.selectedHeight.accept(Int(text) ?? 145)
    }
  }
}
