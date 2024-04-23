//
//  NicknameView.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/12.
//

import UIKit

import DSKit

final class NicknameView: TFBaseView {

  lazy var nicknameInputView = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }

  lazy var titleLabel: UILabel = UILabel().then {
    $0.text = "닉네임을 알려주세요"
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.asColor(targetString: "닉네임", color: DSKitAsset.Color.neutral50.color)
    $0.font = .thtH1B
  }

  lazy var nicknameInputField = TFTextField(
    description: "폴링에서 활동할 자유로운 호칭을 설정해주세요",
    totalCount: 20
  )

  lazy var nextBtn = CTAButton(btnTitle: "->", initialStatus: false)

  override func makeUI() {
    addSubview(nicknameInputView)

    nicknameInputView.addSubviews(
      titleLabel,
      nicknameInputField,
      nextBtn
    )

    nicknameInputView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(frame.height * 0.09)
      $0.leading.equalToSuperview().inset(38)
    }

    nicknameInputField.snp.makeConstraints {
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

struct NicknameViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      return NicknameView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
