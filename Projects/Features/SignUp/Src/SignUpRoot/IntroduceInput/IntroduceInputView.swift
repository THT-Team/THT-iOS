//
//  IntroduceInputView.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/24.
//

import UIKit

import DSKit

final class IntroduceInputView: TFBaseView {

  lazy var introduceInputView = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }

  lazy var titleLabel: UILabel = UILabel().then {
    $0.text = "나를 알려주세요"
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.asColor(targetString: "나를 알려", color: DSKitAsset.Color.neutral50.color)
    $0.font = .thtH1B
  }

  lazy var introduceInputField = TFTextView(
    description: "자유롭게 소개해주세요",
    totalCount: 200
  )

  lazy var nextBtn = CTAButton(btnTitle: "->", initialStatus: false)

  override func makeUI() {
    addSubview(introduceInputView)

    introduceInputView.addSubviews(
      titleLabel,
      introduceInputField,
      nextBtn
    )

    introduceInputView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(frame.height * 0.09)
      $0.leading.equalToSuperview().inset(38)
    }

    introduceInputField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(32)
      $0.leading.trailing.equalToSuperview().inset(38)
    }

    nextBtn.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(38)
      $0.height.equalTo(54)
      $0.width.equalTo(100)
    }
    nextBtn.bottomAnchor.constraint(equalTo: self.keyboardLayoutGuide.topAnchor).isActive = true
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct IntroduceInputViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      let view = IntroduceInputView()
      view.introduceInputField.render(state: .text(text: "입력"))
      return view
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
