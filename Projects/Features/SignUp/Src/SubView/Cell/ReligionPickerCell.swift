//
//  ReligionPickerCell.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/25.
//

import UIKit

import DSKit

final class ReligionPickerCell: TFBaseCollectionViewCell {

  lazy var religionLabel: UILabel = UILabel().then {
    $0.font = .thtH4Sb
    $0.backgroundColor = .clear
    $0.textAlignment = .center
    $0.textColor = DSKitAsset.Color.neutral900.color
  }

  override func makeUI() {
    contentView.addSubview(religionLabel)
    contentView.layer.masksToBounds = true
    contentView.layer.cornerRadius = 10

    religionLabel.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(15)
    }
  }

  func bind(_ text: String) {
    religionLabel.text = text
  }

  func updateCell(_ isSelected: Bool) {
    contentView.backgroundColor = isSelected
    ? DSKitAsset.Color.primary500.color
    : DSKitAsset.Color.disabled.color
  }
}
