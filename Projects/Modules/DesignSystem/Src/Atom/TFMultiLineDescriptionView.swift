//
//  TFMultiLineDescriptionView.swift
//  DSKit
//
//  Created by Kanghos on 8/1/24.
//

import UIKit

import Then

public extension UILabel {
  static func createMultiLineDescriptionLabel() -> UILabel {
    UILabel().then {
      $0.font = .thtCaption1M
      $0.textColor = DSKitAsset.Color.neutral400.color
      $0.textAlignment = .left
      $0.numberOfLines = 0
    }
  }

  static func createOneLineDescriptionLabel() -> UILabel {
    UILabel().then {
      $0.font = .thtP2M
      $0.textColor = DSKitAsset.Color.neutral400.color
      $0.textAlignment = .left
      $0.numberOfLines = 1
    }
  }
}

public class TFMultiLineDescriptionView: TFBaseView {
  private lazy var infoImageView = UIImageView().then {
    $0.image = DSKitAsset.Image.Icons.explain.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = DSKitAsset.Color.neutral400.color
  }

  private lazy var descLabel = UILabel.createMultiLineDescriptionLabel()

  public init(description: String) {
    super.init(frame: .zero)
    self.descLabel.text = description
    makeUI()
  }

  public override func makeUI() {
    addSubviews(infoImageView, descLabel)

    infoImageView.snp.makeConstraints {
      $0.leading.top.equalToSuperview()
      $0.size.equalTo(16.adjustedH)
    }

    descLabel.snp.makeConstraints {
      $0.leading.equalTo(infoImageView.snp.trailing).offset(6.adjusted)
      $0.top.equalTo(infoImageView)
      $0.height.greaterThanOrEqualTo(20.adjustedH)
      $0.bottom.trailing.equalToSuperview()
    }
  }
}
