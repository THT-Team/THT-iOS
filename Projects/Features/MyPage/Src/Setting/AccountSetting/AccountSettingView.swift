//
//  AccountSettingView.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/13/24.
//

import UIKit

import DSKit

final class AccountSettingView<CellType: MyPageDefaultTableViewCell>: MyPageDefaultTableView<CellType> {

  var deactivateBtn = TFTextButton(title: "탈퇴하기")

  override func makeUI() {
    super.makeUI()

    self.addSubview(deactivateBtn)

    deactivateBtn.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.height.equalTo(50)
      $0.bottom.equalToSuperview().offset(-30)
    }
  }
}
