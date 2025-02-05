//
//  PrefetGenderVM.swift
//  MyPage
//
//  Created by kangho lee on 7/23/24.
//

import Foundation

import Core
import RxSwift
import RxCocoa
import DSKit
import MyPageInterface
import SignUpInterface
import Domain

struct PreferGenderItemVM {
  let value: Gender
  var isSelected: Bool
}

final class PreferGenderVM: TFBaseCollectionVM<Gender, TFSimpleItemVM<Gender>> {

  override func processUseCase(value: Gender) -> Driver<Gender> {
    self.useCase.updatePreferGender(value)
      .map { _ in value }
      .asDriver { error in

        return .empty()
      }
  }
  override func sendUserStore(item: Gender) {
    userStore.send(action: .preferGender(item))
  }
}
