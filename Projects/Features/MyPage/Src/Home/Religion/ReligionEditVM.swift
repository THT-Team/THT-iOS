//
//  ReligionEditVM.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/24/24.
//

import Foundation

import SignUpInterface

import RxCocoa
import RxSwift

final class ReligionEditVM: TFBaseCollectionVM<Religion, TFSimpleItemVM<Religion>> {
  override func processUseCase(value: Religion) -> Driver<Religion> {
    self.useCase.updateReligion(value)
      .map { value }
      .asDriver { error in
        return .empty()
      }
  }

  override func sendUserStore(item: Religion) {
    self.userStore.send(action: .religion(item))
  }
}