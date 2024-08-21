//
//  WithdrawalCompleteView.swift
//  MyPage
//
//  Created by Kanghos on 7/4/24.
//

import UIKit

import DSKit

import MyPageInterface

final class WithdrawalCompleteViewController: TFBaseViewController {
  weak var delegate: MySettingCoordinatingActionDelegate?

  private let mainView = TFEmptyView(
    image: DSKitAsset.Bx.withdraw.image,
    title: "그동안 이용해주셔서 감사합니다.",
    subTitle: "ㅇ먼리ㅏㅓ닝ㄹ", 
    buttonTitle: "홈으로 돌아가기"
  )

  override func loadView() {
    self.view = mainView
  }

  override func bindViewModel() {
    mainView.button.rx.tap
      .bind(with: self) { owner, _ in
        owner.delegate?.invoke(.toRoot)
      }.disposed(by: disposeBag)
  }
}
