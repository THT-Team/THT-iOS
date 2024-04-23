//
//  HeightView.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit

import DSKit

class HeightPickerView: TFBaseView {
  lazy var container = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }

  lazy var titleLabel: UILabel = UILabel().then {
    $0.text = "키을 입력해주세요"
    $0.textColor = DSKitAsset.Color.neutral300.color
    $0.font = .thtH1B
    $0.asColor(targetString: "키", color: DSKitAsset.Color.neutral50.color)
  }

  lazy var heightLabel: UILabel = UILabel().then {
    $0.textAlignment = .left
    $0.font = .thtH2B
    $0.text = "145 cm"
    $0.textColor = DSKitAsset.Color.neutral400.color
  }

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
      titleLabel,
      heightLabel,
      infoImageView, descLabel,
      nextBtn
    )
    container.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(30)
      $0.leading.trailing.equalToSuperview().inset(30)
    }

    heightLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(30)
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.height.equalTo(50)
    }

    infoImageView.snp.makeConstraints {
      $0.leading.equalTo(heightLabel.snp.leading)
      $0.width.height.equalTo(16)
      $0.top.equalTo(heightLabel.snp.bottom).offset(16)
    }

    descLabel.snp.makeConstraints {
      $0.leading.equalTo(infoImageView.snp.trailing).offset(6)
      $0.top.equalTo(heightLabel.snp.bottom).offset(16)
      $0.trailing.equalToSuperview().inset(38)
    }
    nextBtn.snp.makeConstraints {
      $0.top.equalTo(descLabel.snp.bottom).offset(30)
      $0.trailing.equalTo(heightLabel)
      $0.height.equalTo(50)
      $0.width.equalTo(60)
    }
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct HeightViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      return HeightPickerView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
