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

public final class EmailEditRootVM: ViewModelType {
  public struct Input {
    let tap: Signal<Void>
  }
  
  public struct Output {
    let model: Driver<SingleSettingModel>
    let toast: Signal<String>
  }
  
  private let email: String
  private var disposeBag = DisposeBag()
  private let toastSignal = PublishRelay<String>()

  var onUpdate: ((String) -> Void)?

  init(email: String) {
    self.email = email
  }
  
  public func transform(input: Input) -> Output {
    let toast = PublishRelay<String>()
    
    let model = SingleSettingModel(header: "등록한 이메일", footer: "이메일이 변경된 경우 업데이트를 해주세요.", content: email)
    
    input.tap
      .emit(with: self) { owner, _ in
        owner.onUpdate?(owner.email)
      }.disposed(by: disposeBag)
    
    toastSignal
      .bind(to: toast)
      .disposed(by: disposeBag)
    
    return Output(model: Driver.just(model), toast: toast.asSignal())
  }
}
