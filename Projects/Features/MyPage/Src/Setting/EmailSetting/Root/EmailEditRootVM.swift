//
//  EmailEditRootVM.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/27/24.
//

import Foundation
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

public protocol EmailEditRootViewDelegate: AnyObject {
  func didTapOnRootUpdateEmail(_ email: String)
}

final class EmailEditRootVM: ViewModelType {
  struct Input {
    let tap: Signal<Void>
  }
  
  struct Output {
    let model: Driver<SingleSettingModel>
    let toast: Signal<String>
  }
  
  private let email: String
  private var disposeBag = DisposeBag()
  private let toastSignal = PublishRelay<String>()
  weak var delegate: EmailEditRootViewDelegate?
  
  init(email: String) {
    self.email = email
  }
  
  func transform(input: Input) -> Output {
    let toast = PublishRelay<String>()
    
    let model = SingleSettingModel(header: "등록한 이메일", footer: "이메일이 변경된 경우 업데이트를 해주세요.", content: email)
    
    input.tap
      .emit(with: self) { owner, _ in
        owner.delegate?.didTapOnRootUpdateEmail(owner.email)
      }.disposed(by: disposeBag)
    
    toastSignal
      .bind(to: toast)
      .disposed(by: disposeBag)
    
    return Output(model: Driver.just(model), toast: toast.asSignal())
  }
}
