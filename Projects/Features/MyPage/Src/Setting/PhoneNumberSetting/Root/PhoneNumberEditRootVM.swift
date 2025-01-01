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

public final class PhoneNumberEditRootVM: ViewModelType {
  public struct Input {
    let tap: Signal<Void>
  }
  
  public struct Output {
    let model: Driver<SingleSettingModel>
    let toast: Signal<String>
  }
  
  private let phoneNumber: String
  private var disposeBag = DisposeBag()
  private let toastSignal = PublishRelay<String>()

  var onUpdate: ((String) -> Void)?

  init(phoneNumber: String) {
    self.phoneNumber = phoneNumber
  }
  
  public func transform(input: Input) -> Output {
    let toast = PublishRelay<String>()
    
    let model = SingleSettingModel(header: "가입된 핸드폰 번호", footer: "핸드폰 번호가 변경된 경우 업데이트를 해주세요.", content: phoneNumber)
    
    input.tap
      .emit(with: self) { owner, _ in
        owner.onUpdate?((owner.phoneNumber))
      }.disposed(by: disposeBag)
    
    toastSignal
      .bind(to: toast)
      .disposed(by: disposeBag)
    
    return Output(model: Driver.just(model), toast: toast.asSignal())
  }
}
