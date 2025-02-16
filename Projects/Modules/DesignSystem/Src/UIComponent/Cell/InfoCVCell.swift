//
//  InfoCVCell.swift
//  DSKit
//
//  Created by Kanghos on 1/13/25.
//

import UIKit

public final class InfoCVCell: TFBaseCollectionViewCell {
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .thtP2Sb
    label.textColor = DSKitAsset.Color.neutral50.color.withAlphaComponent(0.6)
    label.text = "칩 텍스트"
    label.textAlignment = .left
    return label
  }()

  private lazy var contentLabel: TFPaddingLabel = {
    let label = TFPaddingLabel(padding: .init(top: 4, left: 10, bottom: 4, right: 10))
    label.font = .thtP2M
    label.textColor = DSKitAsset.Color.neutral50.color
    label.textAlignment = .center
    label.backgroundColor = DSKitAsset.Color.neutral700.color
    label.layer.cornerRadius = 10
    label.layer.masksToBounds = true
    return label
  }()

  public override func makeUI() {
    contentView.backgroundColor = .clear
    contentView.addSubviews(titleLabel, contentLabel)

    titleLabel.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }

    contentLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(14)
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-10)
      $0.bottom.equalToSuperview()
    }
  }
  
  public override func layoutSubviews() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.contentLabel.layer.cornerRadius = self.contentLabel.frame.height / 2
    }
  }

  public func bind(_ title: String, _ content: String) {
    self.titleLabel.text = title
    self.contentLabel.text = content

    setNeedsLayout()
  }
}
