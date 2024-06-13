//
//  TagCollectionViewCell.swift
//  Falling
//
//  Created by Kanghos on 2023/10/02.
//

import UIKit

//import LikeInterface

public final class TagCollectionViewCell: UICollectionViewCell {
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 5
    stackView.alignment = .center
//    stackView.distribution = .fill
    return stackView
  }()
  private lazy var emojiView: UILabel = {
    let label = UILabel()
    label.font = UIFont.thtSubTitle1R
    label.text = "🍅"
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

  override init(frame: CGRect) {
    super.init(frame: .zero)

    setUpView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setUpView() {
    contentView.backgroundColor = DSKitAsset.Color.neutral700.color
    contentView.clipsToBounds = true
    contentView.addSubview(stackView)
    
    stackView.addArrangedSubviews([emojiView, titleLabel])
    stackView.arrangedSubviews.forEach { subViews in
      subViews.snp.makeConstraints {
        $0.height.equalTo(30)
      }
    }
    stackView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().offset(-15)
    }
  }
//
  public override func layoutSubviews() {
    super.layoutSubviews()
    setUpLayer()
  }

  private func setUpLayer() {
    contentView.layer.cornerRadius = contentView.frame.height / 2
    contentView.layer.masksToBounds = true
  }

  public func setFont(_ font: UIFont) {
    titleLabel.font = font
    emojiView.font = font
  }

  public func bind(_ viewModel: TagItemViewModel) {
    self.titleLabel.text = viewModel.title
    self.emojiView.text = viewModel.emoji
  }
}

public struct TagItemViewModel {
  public let emojiCode: String
  public let title: String

  public var emoji: String {
    emojiCode.unicodeToEmoji()
  }

  public init(emojiCode: String, title: String) {
    self.emojiCode = emojiCode
    self.title = title
  }
}
