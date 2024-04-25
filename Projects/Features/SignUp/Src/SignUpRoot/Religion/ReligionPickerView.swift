//
//  ReligionPickerView.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import UIKit

import DSKit

final class ReligionPickerView: TFBaseView {
  lazy var container = UIView().then {
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }

  lazy var titleLabel: UILabel = UILabel().then {
    $0.text = "종교를 알려주세요"
    $0.textColor = DSKitAsset.Color.neutral300.color
    $0.font = .thtH1B
    $0.asColor(targetString: "종교", color: DSKitAsset.Color.neutral50.color)
  }

  lazy var ReligionPickerView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
      .then {
        $0.itemSize = CGSize(width: 100, height: 60)
      }
  ).then {
    $0.register(cellType: ReligionPickerCell.self)
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
    $0.showsHorizontalScrollIndicator = false
    $0.showsVerticalScrollIndicator = false
    $0.isScrollEnabled = false
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
      ReligionPickerView,
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

    ReligionPickerView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(35)
      $0.leading.trailing.equalToSuperview().inset(30)
      $0.height.equalTo(140)
    }

    infoImageView.snp.makeConstraints {
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.width.height.equalTo(16)
      $0.top.equalTo(ReligionPickerView.snp.bottom).offset(16)
    }

    descLabel.snp.makeConstraints {
      $0.leading.equalTo(infoImageView.snp.trailing).offset(6)
      $0.top.equalTo(ReligionPickerView.snp.bottom).offset(16)
      $0.trailing.equalToSuperview().inset(38)
    }
    nextBtn.snp.makeConstraints {
      $0.top.equalTo(descLabel.snp.bottom).offset(30)
      $0.trailing.equalTo(descLabel)
      $0.height.equalTo(50)
      $0.width.equalTo(60)
    }
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ReligionPickerViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      return ReligionPickerView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
