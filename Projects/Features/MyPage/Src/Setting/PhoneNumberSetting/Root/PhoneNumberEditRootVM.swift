//
//  PhoneNumberEditRootVM.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/27/24.
//

import Foundation
import Core

import RxSwift
import RxCocoa

public protocol PhoneNumberEditRootViewDelegate: AnyObject {
  func didTapOnRootUpdatePhoneNum(_ phoneNumber: String)
}

final class PhoneNumberEditRootVM: ViewModelType {
  struct Input {
    let tap: Signal<Void>
  }
  
  struct Output {
    let model: Driver<SingleSettingModel>
    let toast: Signal<String>
  }
  
  private let phoneNumber: String
  private var disposeBag = DisposeBag()
  private let toastSignal = PublishRelay<String>()
  weak var delegate: PhoneNumberEditRootViewDelegate?
  
  init(phoneNumber: String) {
    self.phoneNumber = phoneNumber
  }
  
  func transform(input: Input) -> Output {
    let toast = PublishRelay<String>()
    
    let model = SingleSettingModel(header: "가입된 핸드폰 번호", footer: "핸드폰 번호가 변경된 경우 업데이트를 해주세요.", content: phoneNumber)
    
    input.tap
      .emit(with: self) { owner, _ in
        owner.delegate?.didTapOnRootUpdatePhoneNum(owner.phoneNumber)
      }.disposed(by: disposeBag)
    
    toastSignal
      .bind(to: toast)
      .disposed(by: disposeBag)
    
    return Output(model: Driver.just(model), toast: toast.asSignal())
  }
}
