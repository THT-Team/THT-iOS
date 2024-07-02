//
//  TFSelectableCVCell.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/23/24.
//

import UIKit

import DSKit

public protocol SelectableCellType {
  func updateCell(_ isSelected: Bool)
}

final class TFSelectableCVCell: TFBaseCollectionViewCell, SelectableCellType, textBindable {
  public override var isHighlighted: Bool {
    didSet {

      guard isHighlighted else { return }
      HapticFeedbackManager.shared.triggerImpactFeedback(style: .soft)
      UIView.animate(
        withDuration: 0.1,
        animations: { self.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)},
        completion: { finished in
          UIView.animate(withDuration: 0.1) { self.transform = .identity }
        })
    }
  }

  lazy var titleLabel: UILabel = UILabel().then {
    $0.font = .thtH4Sb
    $0.textAlignment = .center
    $0.textColor = DSKitAsset.Color.neutral900.color
  }

  override func makeUI() {
    contentView.addSubview(titleLabel)
    contentView.layer.masksToBounds = true
    contentView.layer.cornerRadius = 10

    titleLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  func bind(_ text: String) {
    titleLabel.text = text
  }

  func updateCell(_ isSelected: Bool) {
    contentView.backgroundColor = isSelected
    ? DSKitAsset.Color.primary500.color
    : DSKitAsset.Color.disabled.color
  }
}
