//
//  SmokingVM.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/23/24.
//

import Foundation

import Core
import RxSwift
import RxCocoa
import DSKit
import MyPageInterface
import Domain

final class SmokingEditVM: TFBaseCollectionVM<Frequency, TFSimpleItemVM<Frequency>>  {

  override func processUseCase(value: Frequency) -> Driver<Frequency> {
    self.useCase.updateSmoking(value)
      .map { value }
      .asDriver { error -> Driver<Frequency> in
        return .empty()
      }
  }

  override func sendUserStore(item: Frequency) {
    self.userStore.send(action: .smoke(item))
  }
}


