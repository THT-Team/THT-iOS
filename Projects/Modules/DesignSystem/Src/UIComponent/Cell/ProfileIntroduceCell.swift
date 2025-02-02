//
//  ProfileIntroduceCell.swift
//  Falling
//
//  Created by Kanghos on 2023/10/05.
//

import UIKit

public final class ProfileIntroduceCell: TFBaseCollectionViewCell {

  private lazy var textView: UITextView = {
    let textView = UITextView()
    textView.textColor = DSKitAsset.Color.neutral50.color
    textView.font = UIFont.thtP2M
    textView.isScrollEnabled = false
    textView.isEditable = false
    textView.textContainerInset = .init(top: 12, left: 5, bottom: 12, right: 5)
    textView.contentInset = .zero
    textView.textAlignment = .left
    textView.backgroundColor = DSKitAsset.Color.neutral700.color
    textView.clipsToBounds = true
    textView.layer.cornerRadius = 12
    return textView
  }()

  public override func makeUI() {
    contentView.addSubview(textView)
    textView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.greaterThanOrEqualTo(40)
      $0.bottom.equalToSuperview().offset(-24)
    }
  }

  public override func prepareForReuse() {
    super.prepareForReuse()

    self.textView.text = nil
  }

  public func bind(_ text: String?) {
    self.textView.text = text
  }
}
