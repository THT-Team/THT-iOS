//
//  TFTopicBarView.swift
//  Falling
//
//  Created by Kanghos on 2023/09/14.
//

import UIKit

import SnapKit

final class TFTopicBarView: TFBaseView {
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 10
    stackView.distribution = .fill
    stackView.alignment = .center
    return stackView
  }()
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
    label.numberOfLines = 2
    label.textAlignment = .left
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
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func makeUI() {
    self.backgroundColor = UIColor(named: "TopicBackground")
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor(named: "TopicBorder")?.cgColor

    stackView.addArrangedSubviews([titleLabel, contentLabel])
    self.addSubviews([stackView, closeButton])

    stackView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.top.bottom.equalToSuperview().inset(8)
      $0.trailing.equalTo(closeButton.snp.leading).offset(-8)
    }
    closeButton.snp.makeConstraints {
      $0.size.equalTo(18)
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(14)
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
