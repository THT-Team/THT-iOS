//
//  NicknameViewModel.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/12.
//

import Foundation
import SignUpInterface

import Core

import RxCocoa
import RxSwift

final class NicknameInputViewModel: ViewModelType {
  private let useCase: SignUpUseCaseInterface
  private let userInfoUseCase: UserInfoUseCaseInterface

  weak var delegate: SignUpCoordinatingActionDelegate?

  private var disposeBag = DisposeBag()

  init(useCase: SignUpUseCaseInterface, userInfoUseCase: UserInfoUseCaseInterface) {
    self.useCase = useCase
    self.userInfoUseCase = userInfoUseCase
  }

  struct Input {
    let viewWillAppear: Driver<Void>
    let nickname: Driver<String>
    let nextBtn: Driver<Void>
  }

  struct Output {
    let initialValue: Driver<String?>
    let validate: Driver<Bool>
    let errorField: Driver<String>
  }

  func transform(input: Input) -> Output {
    let text = input.nickname
    let errorTracker = PublishSubject<Error>()
    let outputText = BehaviorRelay<String?>(value: nil)
    let userinfo = input.viewWillAppear
      .flatMapLatest(with: self) { owner, _ in
        owner.userInfoUseCase.fetchUserInfo()
          .asDriver(onErrorJustReturn: .init(phoneNumber: ""))
      }

    let initialNickname = userinfo.map { $0.name }

    let isDuplicate = text
      .debounce(.milliseconds(500))
      .distinctUntilChanged()
      .filter(validateNickname)
      .flatMapLatest(with: self) { owner, text in
        owner.useCase.checkNickname(nickname: text)
          .asDriver(onErrorRecover: { error in
            errorTracker.onNext(error)
            return .empty()
          })
      }

    let isAvailableNickname = isDuplicate.map { $0 == false }

    isDuplicate
      .filter { $0 }
      .debug("isDuplicate to ErrorTracker")
      .map { _ in SignUpError.duplicateNickname }
      .drive(errorTracker)
      .disposed(by: disposeBag)

    let updatedUserInfo = Driver.combineLatest(text, userinfo) {
      var mutable = $1
      mutable.name = $0
      return mutable
    }

    input.nextBtn
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(updatedUserInfo)
      .drive(with: self) { owner, userinfo in
        owner.userInfoUseCase.updateUserInfo(userInfo: userinfo)
        owner.delegate?.invoke(.nextAtNickname)
      }
      .disposed(by: disposeBag)
    
    let errorField = errorTracker
      .compactMap { error in
        switch error {
        case SignUpError.duplicateNickname:
          return "이미 사용중인 닉네임입니다."
        default:
          return error.localizedDescription
        }
      }.asDriverOnErrorJustEmpty()

    return Output(
      initialValue: initialNickname,
      validate: isAvailableNickname,
      errorField: errorField
    )
  }

  func validateNickname(_ text: String) -> Bool {
    !text.isEmpty && text.count < 13 && text.count > 5
  }
}
