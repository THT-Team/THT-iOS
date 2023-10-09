//
//  ProfileIntroduceCell.swift
//  Falling
//
//  Created by Kanghos on 2023/10/05.
//

import UIKit

import SnapKit

final class ProfileIntroduceCell: TFBaseCollectionViewCell {

  private lazy var textView: UITextView = {
    let textView = UITextView()
    textView.textColor = FallingAsset.Color.dimColor2.color
    textView.font = UIFont.thtP2M
    textView.isScrollEnabled = false
    textView.isEditable = false
    textView.textContainerInset = .init(top: 5, left: 5, bottom: 5, right: 5)
    textView.contentInset = .zero
    return textView
  }()

  override func makeUI() {
    contentView.layer.cornerRadius = 12
    contentView.backgroundColor = FallingAsset.Color.neutral700.color
    contentView.clipsToBounds = true
    contentView.addSubview(textView)

    textView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalTo(UIScreen.main.bounds.width - 10 - 12 - 20).priority(.high)
      $0.height.equalTo(100).priority(.low)
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    self.textView.text = nil
  }

  func configure(_ text: String?) {
    self.textView.text = text
    self.textView.invalidateIntrinsicContentSize()
    self.textView.sizeToFit()
    self.textView.setNeedsLayout()
  }
}
