//
//  NicknameView.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/12.
//

import UIKit

import DSKit

final class NicknameView: TFBaseView {

  lazy var titleLabel = UILabel.setTargetBold(text: "닉네임을 알려주세요.", target: "닉네임", font: .thtH1B, targetFont: .thtH1B)

  lazy var nicknameInputField = TFCounterTextField(
    description: "폴링에서 활동할 자유로운 호칭을 설정해주세요",
    maxLength: 12,
    placeholder: "닉네임"
  )

  lazy var nextBtn = TFButton(btnTitle: "->", initialStatus: false)

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color

    addSubviews(
      titleLabel,
      nicknameInputField,
      nextBtn
    )

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(180.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(38.adjusted)
    }

    nicknameInputField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(64.adjustedH)
      $0.leading.trailing.equalTo(titleLabel)
    }

    nextBtn.snp.makeConstraints {
      $0.trailing.equalTo(titleLabel)
      $0.height.equalTo(54.adjustedH)
      $0.width.equalTo(88.adjusted)
      $0.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-16.adjustedH)
    }
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct NicknameViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      return NicknameView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
