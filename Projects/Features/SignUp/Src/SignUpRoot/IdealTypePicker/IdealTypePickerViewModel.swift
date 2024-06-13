//
//  IdealTypeViewModel.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/24.
//

import Foundation

import Core
import SignUpInterface

import RxSwift
import RxCocoa

final class IdealTypeTagPickerViewModel: ViewModelType {
  private let useCase: SignUpUseCaseInterface
  private let userInfoUseCase: UserInfoUseCaseInterface
  weak var delegate: SignUpCoordinatingActionDelegate?
  
  init(useCase: SignUpUseCaseInterface, userInfoUseCase: UserInfoUseCaseInterface) {
    self.useCase = useCase
    self.userInfoUseCase = userInfoUseCase
  }

  struct Input {
    var chipTap: Driver<IndexPath>
    var nextBtnTap: Driver<Void>
  }

  struct Output {
    var chips: Driver<[InputTagItemViewModel]>
    var isNextBtnEnabled: Driver<Bool>
  }

  private var disposeBag = DisposeBag()

  func transform(input: Input) -> Output {

    let chips = BehaviorRelay<[InputTagItemViewModel]>(value: [])

    let userinfo = Driver.just(())
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.userInfoUseCase.fetchUserInfo()
          .catchAndReturn(UserInfo(phoneNumber: ""))
          .asObservable()
      }
      .asDriverOnErrorJustEmpty()

    let local = userinfo.map { $0.idealTypeList }

    let remote = Driver.just(())
      .flatMapLatest { [unowned self] _ in
        self.useCase.idealTypes()
          .asDriver(onErrorJustReturn: [])
      }
      .map { $0.map { InputTagItemViewModel(item: $0, isSelected: false) } }

    Driver.zip(local, remote) { local, remote in
      var mutable = remote

      local.forEach { selectedIndex in
        if let index = mutable.firstIndex(where: { $0.emojiType.idx == selectedIndex }) {
          mutable[index].isSelected = true
        }
      }
      return mutable
    }
    .drive(chips)
    .disposed(by: disposeBag)

    input.chipTap.map { $0.item }
      .withLatestFrom(chips.asDriver()) { index, chips in
        var prev = chips.enumerated().filter { $0.element.isSelected }.map { $0.offset }

        if prev.contains(index) {
          prev.removeAll { $0 == index }
        } else if prev.count < 3 {
          prev.append(index)
        }
        var mutable = chips.map {
          var model = $0
          model.isSelected = false
          return model
        }

        prev.forEach { index in
          mutable[index].isSelected = true
        }

        return mutable
      }.drive(chips)
      .disposed(by: disposeBag)

    let isNextBtnEnabled = chips.asDriver()
      .map { $0.filter { $0.isSelected }.count == 3 }

    input.nextBtnTap
      .withLatestFrom(isNextBtnEnabled)
      .filter { $0 }
      .withLatestFrom(chips.asDriver()) { _, chips in
        chips.filter { $0.isSelected }.map { $0.emojiType.idx }
      }
      .withLatestFrom(userinfo) { items, userinfo in
        var mutable = userinfo
        mutable.idealTypeList = items
        return mutable
      }
      .drive(with: self, onNext: { owner, userinfo in
        owner.userInfoUseCase.updateUserInfo(userInfo: userinfo)
        owner.delegate?.invoke(.nextAtIdealType)
      })
      .disposed(by: disposeBag)

    return Output(
      chips: chips.asDriver(),
      isNextBtnEnabled: isNextBtnEnabled
    )
  }
}
