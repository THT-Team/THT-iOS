//
//  SignUpViewModel.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/22.
//

import Foundation

import RxSwift
import RxCocoa
import AuthInterface
import KakaoSDKAuth
import KakaoSDKUser

import Core

final class AuthRootViewModel: ViewModelType {
  private let useCase: AuthUseCaseInterface

  struct Input {
    let buttonTap: Driver<SNSType>
    let inquiryTap: Signal<Void>
  }

  struct Output {
    let toast: Signal<String>
  }

  weak var delegate: AuthCoordinatingActionDelegate?

  var disposeBag: DisposeBag = DisposeBag()

  init(useCase: AuthUseCaseInterface) {
    self.useCase = useCase
  }

  func transform(input: Input) -> Output {
    let toastPublisher = PublishRelay<String>()
    let buttonTap = input.buttonTap
      .throttle(.milliseconds(500), latest: false)

    buttonTap
      .flatMapLatest(with: self, selector: { owner, snsType -> Driver<AuthNavigation> in
        owner.useCase.auth(snsType)
          .asDriver { error in
            toastPublisher.accept(error.localizedDescription)
            return .empty()
          }
      })
      .drive(with: self) { owner, navigation in
        owner.delegate?.invoke(navigation)
      }
      .disposed(by: disposeBag)

    input.inquiryTap
      .emit(with: self) { owner, _ in
        owner.delegate?.invoke(.inquiry)
      }
      .disposed(by: disposeBag)


    return Output(toast: toastPublisher.asSignal(onErrorSignalWith: .empty()))
  }
}
