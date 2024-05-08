//
//  PreferGenderPickerView.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/18.
//
import UIKit

import DSKit


final class PreferGenderPickerView: TFBaseView {
  lazy var container = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }

  lazy var genderPickerView = TFButtonPickerView(
    title: "선호 성별을 알려주세요.", targetString: "선호 성별",
    options: [
      "여성",
      "남성",
      "모두"
    ]
  )

  lazy var infoImageView: UIImageView = UIImageView().then {
    $0.image = DSKitAsset.Image.Icons.explain.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = DSKitAsset.Color.neutral400.color
  }

  lazy var descLabel: UILabel = UILabel().then {
    $0.text = "마이페이지에서 변경가능합니다."
    $0.font = .thtCaption1M
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.textAlignment = .left
    $0.numberOfLines = 1
  }

  lazy var nextBtn = CTAButton(btnTitle: "->", initialStatus: false)

  override func makeUI() {
    addSubview(container)

    container.addSubviews(
      genderPickerView,
      infoImageView, descLabel,
      nextBtn
    )
    container.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
      $0.bottom.equalToSuperview()
    }

    genderPickerView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(76)
      $0.leading.trailing.equalToSuperview().inset(0)
    }

    infoImageView.snp.makeConstraints {
      $0.leading.equalTo(genderPickerView.snp.leading).offset(30)
      $0.width.height.equalTo(16)
      $0.top.equalTo(genderPickerView.snp.bottom).offset(10)
    }

    descLabel.snp.makeConstraints {
      $0.leading.equalTo(infoImageView.snp.trailing).offset(6)
      $0.top.equalTo(infoImageView)
      $0.trailing.equalToSuperview().inset(38)
    }
    nextBtn.snp.makeConstraints {
      $0.top.equalTo(descLabel.snp.bottom).offset(30)
      $0.trailing.equalTo(descLabel)
      $0.height.equalTo(50)
      $0.width.equalTo(88)
    }
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct PreferGenderPickerViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      return PreferGenderPickerView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
