//
//  WithdrawalDetailCollectionViewCell.swift
//  MyPageInterface
//
//  Created by Kanghos on 7/4/24.
//

import UIKit

import Domain
import DSKit

final class WithdrawalDetailCollectionViewCell: TFBaseCollectionViewCell {
  private lazy var titleLabel = UILabel().then {
    $0.font = .thtSubTitle2R
    $0.textColor = DSKitAsset.Color.neutral300.color
  }

  private lazy var checkImageView = UIImageView().then {
    $0.isHidden = true
    $0.image = DSKitAsset.Image.Component.checkSelect.image
  }

  override func makeUI() {
    contentView.addSubviews(titleLabel, checkImageView)
    
    titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-16)
      $0.leading.equalToSuperview().offset(24)
    }

    checkImageView.snp.makeConstraints {
      $0.size.equalTo(24)
      $0.leading.equalTo(titleLabel.snp.trailing).offset(20)
      $0.trailing.equalToSuperview().inset(20)
      $0.centerY.equalToSuperview()
    }
  }

  override func prepareForReuse() {
    checkImageView.isHidden = true
    super.prepareForReuse()
  }

  func bind(_ model: ReasonModel) {
    titleLabel.text = model.description
    self.checkImageView.isHidden = model.isSelected == false
    self.checkImageView.setNeedsDisplay()
  }
}
