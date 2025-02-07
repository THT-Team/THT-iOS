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

  private lazy var contentContainerView: UIView = {
    let view = UIView()
    view.clipsToBounds = true
    view.layer.masksToBounds = true
    view.backgroundColor = DSKitAsset.Color.neutral700.color
    view.layer.cornerRadius = 25
    return view
  }()

  private lazy var contentLabel: UILabel = {
    let label = UILabel()
    label.font = .thtP2M
    label.textColor = DSKitAsset.Color.neutral50.color
    label.text = "🍅"
    label.textAlignment = .center
    return label
  }()

  public override func makeUI() {
    contentView.backgroundColor = .clear
    contentView.addSubviews(titleLabel, contentContainerView)
    contentContainerView.addSubview(contentLabel)

    titleLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview()
    }

    contentContainerView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(14)
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-10)
      $0.bottom.equalToSuperview()
    }

    contentLabel.snp.makeConstraints {
      $0.top.equalToSuperview() //.offset(4)
      $0.bottom.equalToSuperview() //.offset(-4)
      $0.leading.equalToSuperview().offset(10)
      $0.height.equalTo(30)
      $0.trailing.equalToSuperview().offset(-10)
    }
  }

  public override func layoutSubviews() {
    contentContainerView.layer.cornerRadius = contentContainerView.frame.height / 2
  }

  public func bind(_ title: String, _ content: String) {
    self.titleLabel.text = title
    self.contentLabel.text = content

    setNeedsLayout()
  }
}
