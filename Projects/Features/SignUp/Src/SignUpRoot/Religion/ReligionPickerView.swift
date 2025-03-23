//
//  ReligionPickerView.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import UIKit

import DSKit

final class ReligionPickerView: TFBaseView {
  lazy var titleLabel = UILabel.setTargetBold(text: "종교를 알려주세요", target: "종교", font: .thtH1B, targetFont: .thtH1B)

  lazy var ReligionPickerView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.minimumLineSpacing = 16.adjustedH
      $0.minimumInteritemSpacing = 16.adjustedH
    }
  ).then {
    $0.register(cellType: ReligionPickerCell.self)
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
    $0.showsHorizontalScrollIndicator = false
    $0.showsVerticalScrollIndicator = false
    $0.isScrollEnabled = false
    $0.delegate = self

    $0.delaysContentTouches = false
    $0.canCancelContentTouches = true
  }

  lazy var descriptionView = TFOneLineDescriptionView(description: "마이페이지에서 변경가능합니다.")

  lazy var nextBtn = TFButton(btnTitle: "->", initialStatus: false)

  var collectionViewHeightConstraint: NSLayoutConstraint?

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color

    addSubviews(
      titleLabel,
      ReligionPickerView,
      descriptionView,
      nextBtn
    )

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(180.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(38.adjusted)
    }

    ReligionPickerView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(35)
      $0.leading.trailing.equalTo(titleLabel)
    }

    self.collectionViewHeightConstraint = ReligionPickerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
    collectionViewHeightConstraint?.isActive = true

    descriptionView.snp.makeConstraints {
      $0.top.equalTo(ReligionPickerView.snp.bottom).offset(16.adjustedH)
      $0.leading.trailing.equalTo(titleLabel)
    }

    nextBtn.snp.makeConstraints {
      $0.trailing.equalTo(descriptionView)
      $0.height.equalTo(54.adjustedH)
      $0.width.equalTo(88.adjusted)
      $0.bottom.equalToSuperview().offset(-133.adjustedH)
    }
  }
}

extension ReligionPickerView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let space = 16.adjustedH
    let itemsForLine: CGFloat = 3
    let width = ((collectionView.frame.width - (itemsForLine + 1) * space)) / itemsForLine
    let height = 49.adjustedH
    return CGSize(width: width, height: height)
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ReligionPickerViewPreview: PreviewProvider {

  static var previews: some SwiftUI.View {
    UIViewPreview {
      return ReligionPickerView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
