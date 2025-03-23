//
//  LocationInputView.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/27.
//

import UIKit

import DSKit

final class LocationInputView: TFBaseView {
  lazy var titleLabel = UILabel.setTargetBold(text: "현재 위치를 알려주세요.", target: "현재 위치를", font: .thtH1B, targetFont: .thtH1B)

  lazy var locationField = LocationInputField()

  lazy var nextBtn = TFButton(btnTitle: "->", initialStatus: false)

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color

    addSubviews(
      titleLabel,
      locationField,
      nextBtn
    )

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(180.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(38.adjusted)
    }

    locationField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(30.adjustedH)
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

struct LocationInputViewPreview: PreviewProvider {

  static var previews: some SwiftUI.View {
    UIViewPreview {
      let component = LocationInputView()
      component.locationField.bind("서울시 성북구 성북동")
      return component
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
