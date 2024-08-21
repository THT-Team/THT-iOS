//
//  IntroduceInputView.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/24.
//

import UIKit

import DSKit

final class IntroduceInputView: TFBaseView {

  lazy var titleLabel = UILabel.setTargetBold(text: "나를 알려주세요.", target: "나를 알려", font: .thtH1B, targetFont: .thtH1B)

  lazy var introduceInputField = TFResizableTextView(
    description: "자유롭게 소개해주세요",
    totalCount: 200,
    placeholder: "저의 MBTI는요"
  )

  lazy var nextBtn = TFButton(btnTitle: "->", initialStatus: false)

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color

    addSubviews(
      titleLabel,
      introduceInputField,
      nextBtn
    )
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(180.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(38.adjusted)
    }

    introduceInputField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(30)
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

struct IntroduceInputViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      let view = IntroduceInputView()
//      view.introduceInputField.render(state: .text(text: "입력"))
      return view
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
