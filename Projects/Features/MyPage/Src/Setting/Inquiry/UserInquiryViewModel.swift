//
//  InquiryViewModel.swift
//  MyPage
//
//  Created by kangho lee on 7/27/25.
//

import Foundation

import Domain
import Core

import RxCocoa
import RxSwift

public protocol DefaultOutput {
  var onBackButtonTap: (() -> Void)? { get set }
}

public final class UserInquiryViewModel: ViewModelType, DefaultOutput {
  private var disposeBag = DisposeBag()

  public var onBackButtonTap: (() -> Void)?
  private let useCase: MyPageUseCaseInterface
  
  init(useCase: MyPageUseCaseInterface) {
    self.useCase = useCase
  }

  public struct Input {
    let email: Driver<String>
    let content: Driver<String>
    let btnTap: Signal<Void>
    let policyTap: Signal<Void>
    let cardBtnTap: Signal<Void>
  }

  public struct Output {
    let showCard: Signal<Void>
    let isBtnEnabled: Driver<Bool>
    let emailValidateMessage: Signal<String>
    let toast: Driver<Error>
  }

  public func transform(input: Input) -> Output {
    let email = input.email
    let validateEmail = email.filter { $0.count > 5 }.map { $0.emailValidation() }
    let content = input.content
    let validateContent = content.map { !$0.isEmpty }
    let emailAndContent = Driver.combineLatest(email, content) { (email: $0, content: $1) }
    let errorTracker = PublishSubject<Error>()

    let policyTap = input.policyTap.scan(false, accumulator: { last, _ in !last })
      .asDriver(onErrorJustReturn: false)

    let isBtnEnabled = Driver.combineLatest(validateEmail, validateContent, policyTap) { $0 && $1 && $2 }.startWith(false)
    let showCard = input.btnTap
      .withLatestFrom(isBtnEnabled)
      .filter { $0 }
      .throttle(.milliseconds(300), latest: false)
      .withLatestFrom(emailAndContent)
      .asObservable()
      .flatMapLatest { [weak self] email, content -> RxSwift.Observable<Void> in
        guard let self else { return .empty() }
        return self.useCase.inquiry(email: email, content: content, isEmailAgree: true)
          .asObservable()
          .catch { error in
            errorTracker.onNext(error)
            return .empty()
          }
      }
      .asSignal(onErrorSignalWith: .empty())

    let emailError = validateEmail
      .filter { !$0 }
      .throttle(.milliseconds(300), latest: true)
      .asSignal(onErrorSignalWith: .empty())
      .map { _ in InquiryError.emailInvalidate.message  }


    input.cardBtnTap
      .emit(with: self) { owner, _ in
        owner.onBackButtonTap?()
      }.disposed(by: disposeBag)

    return Output(
      showCard: showCard,
      isBtnEnabled: isBtnEnabled,
      emailValidateMessage: emailError,
      toast: errorTracker.asDriverOnErrorJustEmpty())
  }
}

fileprivate enum InquiryError: Error {
  case emailInvalidate

  var message: String {
    switch self {
    case .emailInvalidate:
      return "이메일 형식이 올바르지 않습니다."
    }
  }
}

