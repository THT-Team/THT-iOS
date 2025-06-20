//
//  InputTagChip.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/24.
//

import UIKit

import Domain
import Core

// Suggest Selectable tag chip confirmed collectionView cell
// it has to status selected and non-selected
public final class InputTagCollectionViewCell: TFBaseCollectionViewCell {
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 5
    stackView.alignment = .center
    stackView.distribution = .fill
    return stackView
  }()

  private lazy var emojiView: UILabel = {
    let label = UILabel()
    label.font = UIFont.thtSubTitle1R
    label.text = ""
    label.numberOfLines = 1
    return label
  }()

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.thtSubTitle1R
    label.textColor = DSKitAsset.Color.neutral50.color
    label.text = "칩 텍스트"
    label.textAlignment = .left
    label.numberOfLines = 1
    return label
  }()

  public override func makeUI() {
    contentView.addSubview(stackView)

    stackView.addArrangedSubviews([emojiView, titleLabel])
    stackView.arrangedSubviews.forEach { subViews in
      subViews.snp.makeConstraints {
        $0.height.equalTo(40)
      }
    }
    stackView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().offset(-10)
    }

    updateStatus(isSelected: false)

    contentView.layer.masksToBounds = true
    contentView.layer.borderColor = DSKitAsset.Color.neutral300.color.cgColor
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    setUpLayer()
  }

  private func setUpLayer() {
    contentView.layer.cornerRadius = contentView.frame.height / 2
  }

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

  public func bind(_ viewModel: InputTagItemViewModel) {
    self.titleLabel.text = viewModel.emojiType.name
    self.emojiView.text = viewModel.emoji
    updateStatus(isSelected: viewModel.isSelected)
  }

  public func updateStatus(isSelected: Bool) {
    contentView.backgroundColor = isSelected
    ? DSKitAsset.Color.primary500.color
    : DSKitAsset.Color.neutral700.color

    titleLabel.textColor = isSelected
    ? DSKitAsset.Color.neutral700.color
    : DSKitAsset.Color.neutral50.color

    contentView.layer.borderWidth = isSelected ? 0 : 1
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct InputTagCellViewPreview: PreviewProvider {

  static var previews: some SwiftUI.View {
    UIViewPreview {
      let component =  InputTagCollectionViewCell()
      component.bind(.init(item: .init(idx: 1, name: "샘플", emojiCode: "U+1F457"), isSelected: false))
      return component
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif

