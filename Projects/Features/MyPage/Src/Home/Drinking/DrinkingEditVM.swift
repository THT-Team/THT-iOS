//
//  DrinkingEditVM.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/23/24.
//

import UIKit

import DSKit

import SignUpInterface
import MyPageInterface

import RxCocoa
import RxSwift
import Domain

final class DrinkingEditVM: TFBaseCollectionVM<Frequency, TFSimpleItemVM<Frequency>>  {

  override func processUseCase(value: Frequency) -> Driver<Frequency> {
    self.useCase.updateDrinking(value)
      .map { value }
      .asDriver { error -> Driver<Frequency> in
        return .empty()
      }
  }

  override func sendUserStore(item: Frequency) {
    self.userStore.send(action: .drink(item))
  }
}
