//
//  HeightView.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit

import DSKit

class HeightPickerView: TFBaseView {
  lazy var titleLabel = UILabel.setTargetBold(text: "키를 입력해주세요.", target: "키", font: .thtH1B, targetFont: .thtH1B)

  lazy var heightLabel: UILabel = UILabel().then {
    $0.textAlignment = .left
    $0.font = .thtH2B
    $0.text = "145 cm"
    $0.textColor = DSKitAsset.Color.neutral400.color
  }

  lazy var descriptionView = TFOneLineDescriptionView(description: "마이페이지에서 변경가능합니다.")

  lazy var nextBtn = TFButton(btnTitle: "->", initialStatus: false)

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color

    addSubviews(
      titleLabel,
      heightLabel,
      descriptionView,
      nextBtn
    )

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(180.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(38.adjusted)
    }

    heightLabel.snp.makeConstraints {
      $0.leading.trailing.equalTo(titleLabel)
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.height.equalTo(50)
    }

    descriptionView.snp.makeConstraints {
      $0.leading.trailing.equalTo(titleLabel)
      $0.top.equalTo(heightLabel.snp.bottom).offset(16.adjustedH)
    }

    nextBtn.snp.makeConstraints {
      $0.trailing.equalTo(descriptionView)
      $0.height.equalTo(54.adjustedH)
      $0.width.equalTo(88.adjusted)
      $0.bottom.equalToSuperview().offset(-133.adjustedH)
    }
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct HeightViewPreview: PreviewProvider {

  static var previews: some SwiftUI.View {
    UIViewPreview {
      return HeightPickerView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
