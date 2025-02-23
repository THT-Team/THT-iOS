//
//  LikeNoticeHeader.swift
//  Like
//
//  Created by Kanghos on 2/19/25.
//

import UIKit

import DSKit

final class LikeNoticeHeader: TFBaseCollectionReusableView {
  var disposeBag = DisposeBag()
  
  let headerLabel: UILabel = {
    let label = UILabel()
    label.font = .thtSubTitle1Sb
    label.backgroundColor = DSKitAsset.Color.neutral900.color
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    label.text = "무디 100명이 나를 좋아해요 :)"
    label.layer.cornerRadius = 12
    label.clipsToBounds = true
    return label
  }()

  let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral300.color
    label.font = UIFont.thtP1M
    return label
  }()

  override func makeUI() {
    addSubviews(headerLabel, titleLabel)

    // FIXME: 수치
    headerLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(Metric.horizontalPadding)
      $0.top.equalToSuperview().offset(10)
      $0.height.equalTo(42)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(headerLabel.snp.bottom).offset(28.adjustedH)
      $0.leading.equalToSuperview().offset(12.adjusted)
      $0.height.greaterThanOrEqualTo(30)
      $0.bottom.equalToSuperview().offset(-10.adjustedH)
    }
  }

  func bind(_ text: (target: String, fullText: String)) {
    headerLabel.text = text.fullText
    headerLabel.asColor(targetString: text.target, color: DSKitAsset.Color.primary500.color)
    self.setNeedsDisplay()
  }

  func set(_ title: String?) {
    self.titleLabel.text = title
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
//    headerLabel.text = ""
  }
}
