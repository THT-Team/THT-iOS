//
//  TFTopicBarView.swift
//  Falling
//
//  Created by Kanghos on 2023/09/14.
//

import UIKit

import SnapKit

final class TFTopicBarView: UIView {
  private lazy var titleLabel: TFPaddingLabel = {
    let label = TFPaddingLabel()
    label.layer.borderWidth = 1
    label.layer.borderColor = FallingAsset.Color.primary500.color.cgColor
    label.textColor = FallingAsset.Color.primary500.color
    label.font = UIFont.thtSubTitle2Sb
    label.textAlignment = .center
    label.clipsToBounds = true
    return label
  }()
  
  private lazy var contentLabel: UILabel = {
    let label = UILabel()
    label.textColor = FallingAsset.Color.neutral50.color
    label.font = UIFont.thtSubTitle2Sb
    label.numberOfLines = 0
    label.lineBreakMode = .byCharWrapping
    return label
  }()
  
  lazy var closeButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.plain()
    config.image = FallingAsset.Image.close.image.withTintColor(
      FallingAsset.Color.neutral50.color,
      renderingMode: .alwaysOriginal
    )
    config.imagePlacement = .all
    config.baseBackgroundColor = UIColor(named: "TopicBackground")
    button.configuration = config
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setUpViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpViews() {
    self.backgroundColor = UIColor(named: "TopicBackground")
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor(named: "TopicBorder")?.cgColor
    
    [titleLabel, contentLabel, closeButton].forEach {
      self.addSubview($0)
    }
    titleLabel.setContentHuggingPriority(.defaultLow + 1, for: .horizontal)
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(12)
      $0.height.equalTo(35)
      $0.centerY.equalToSuperview()
    }
    contentLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    contentLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.top.bottom.equalToSuperview().inset(14)
      $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
      $0.trailing.equalTo(closeButton.snp.leading).offset(-8)
    }
    closeButton.snp.makeConstraints {
      $0.size.equalTo(18)
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(20)
    }
  }
  
  override func layoutSubviews() {
    self.layer.cornerRadius = self.frame.height / 2
    titleLabel.layer.cornerRadius = titleLabel.frame.height / 2
    titleLabel.layer.masksToBounds = true
    titleLabel.layoutIfNeeded()
  }
  
  func configure(title: String, content: String) {
    titleLabel.text = title
    contentLabel.text = content
  }
}
