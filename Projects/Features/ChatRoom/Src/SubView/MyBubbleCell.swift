//
//  MyBubbleCell.swift
//  Chat
//
//  Created by Kanghos on 2024/01/14.
//

import UIKit

import DSKit

import Domain

final class MyChatBubbleCell: TFBaseCollectionViewCell {

  private lazy var contentLabel: TFPaddingLabel = {
    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let label = TFPaddingLabel(padding: padding)
    label.backgroundColor = DSKitAsset.Color.primary500.color
    label.textColor = DSKitAsset.Color.neutral700.color
    label.font = UIFont.thtP2R
    label.numberOfLines = 0
    label.layer.cornerRadius = 12
    label.clipsToBounds = true
    return label
  }()

  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = UIFont.thtCaption2R
    label.textAlignment = .right
    label.isHidden = true
    return label
  }()

  override func makeUI() {
    self.contentView.addSubviews(contentLabel, dateLabel)
    self.contentView.backgroundColor = DSKitAsset.Color.neutral700.color

    contentLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    contentLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(13)
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalToSuperview().offset(-13)
    }

    dateLabel.snp.makeConstraints {
      $0.trailing.equalTo(contentLabel.snp.leading).offset(-8)
      $0.height.equalTo(20)
      $0.bottom.equalTo(contentLabel)
    }
  }

  // 경우의 수 2가지
  /*
   3. 메세지 + 날짜
   4. 메세지만
   */
  func bind(_ item: BubbleReactor) {
//    self.contentLabel.text = item.msg
//    self.dateLabel.text = item.dateTime.toTimeString()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.dateLabel.isHidden = true
    contentLabel.text = nil
    dateLabel.text = nil
  }
}

