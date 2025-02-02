//
//  BaseBubbleCell.swift
//  ChatRoom
//
//  Created by Kanghos on 1/25/25.
//

import UIKit

import DSKit

import Kingfisher
import ChatInterface
import Domain
import ReactorKit

class BaseBubbleCell: TFBaseCollectionViewCell, View {

  enum Metric {
    static let verticalSpacing: CGFloat = 8
    static let horizontalSpacing: CGFloat = 16
  }

  lazy var contentLabel: TFPaddingLabel = {
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

  lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = UIFont.thtCaption2R
    label.textAlignment = .right
    return label
  }()

  override func makeUI() {
    self.contentView.addSubviews(contentLabel, dateLabel)
    self.contentView.backgroundColor = DSKitAsset.Color.neutral700.color

    contentLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(Metric.verticalSpacing)
      $0.trailing.equalToSuperview().offset(-Metric.horizontalSpacing)
      $0.height.greaterThanOrEqualTo(35)
      $0.bottom.equalToSuperview().offset(-Metric.verticalSpacing)
    }

    dateLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(Metric.verticalSpacing).priority(.low)
      $0.trailing.equalTo(contentLabel.snp.leading).offset(-8)
      $0.height.equalTo(20)
      $0.bottom.equalTo(contentLabel)
    }
  }

  public func bind(reactor: BubbleReactor) {
    reactor.state.map(\.message)
      .bind(to: contentLabel.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map(\.dateText)
      .bind(to: dateLabel.rx.text)
      .disposed(by: disposeBag)
    setNeedsLayout()
    layoutIfNeeded()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    contentLabel.text = nil
    dateLabel.text = nil
  }
}

