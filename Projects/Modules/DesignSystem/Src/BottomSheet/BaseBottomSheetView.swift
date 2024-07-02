//
//  BaseBottomSheetView.swift
//  DSKit
//
//  Created by Kanghos on 7/23/24.
//

import UIKit

import Then
import SnapKit

public struct TargetTitle {
  let text: String
  let target: String
}

open class BaseBottomSheetView: TFBaseView {
  private let targetTitle: TargetTitle
  private let btnTitle: String

  public lazy var button = CTAButton(btnTitle: btnTitle, initialStatus: false)
  public let vStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 10
  }
  public lazy var titleLabel = UILabel.setH4TargetBold(text: targetTitle.text, target: targetTitle.target)

  public init(targetTitle: TargetTitle, btnTitle: String) {
    self.targetTitle = targetTitle
    self.btnTitle = btnTitle
    super.init(frame: .zero)
  }

  open override func makeUI() {
    backgroundColor = DSKitAsset.Color.neutral600.color
    addSubviews(titleLabel, vStackView, button)

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview().offset(38.adjusted)
    }

    vStackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10.adjustedH)
      $0.leading.trailing.equalTo(titleLabel)
    }

    button.snp.makeConstraints {
      $0.top.equalTo(vStackView.snp.bottom).offset(10.adjustedH)
      $0.leading.trailing.equalTo(vStackView).inset(38.adjusted)
      $0.height.equalTo(54.adjustedH)
      $0.bottom.equalTo(safeAreaLayoutGuide).offset(-30.adjustedH)
    }
  }
}
