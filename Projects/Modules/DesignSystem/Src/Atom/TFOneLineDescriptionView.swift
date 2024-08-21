//
//  TFOneLineDescriptionView.swift
//  DSKit
//
//  Created by Kanghos on 8/1/24.
//

import UIKit

import SnapKit
import Then

extension UIButton {
  static func makeClearBtn() -> UIButton {
    UIButton().then {
      $0.setImage(DSKitAsset.Image.Icons.closeCircle.image, for: .normal)
      $0.setTitle(nil, for: .normal)
      $0.backgroundColor = .clear
      $0.isHidden = true
    }
  }
}

public class TFOneLineDescriptionView: TFBaseView {
  private(set) lazy var infoImageView = UIImageView().then {
    $0.image = DSKitAsset.Image.Icons.explain.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = DSKitAsset.Color.neutral400.color
  }

  private(set) lazy var descLabel = UILabel.createOneLineDescriptionLabel()

  public init(description: String) {
    super.init(frame: .zero)
    self.descLabel.text = description
    makeUI()
  }

  public override func makeUI() {
    addSubviews(infoImageView, descLabel)

    descLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalTo(infoImageView.snp.trailing).offset(6.adjusted)
      $0.height.greaterThanOrEqualTo(20.adjustedH)
      $0.bottom.trailing.equalToSuperview()
    }

    infoImageView.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.size.equalTo(16.adjustedH)
      $0.centerY.equalToSuperview()
    }
  }
}
