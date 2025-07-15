//
//  BaseBubbleCell.swift
//  ChatRoom
//
//  Created by Kanghos on 1/25/25.
//

import UIKit

import DSKit

import Domain
import ReactorKit

class BaseBubbleCell: TFBaseCollectionViewCell, View {

  enum Metric {
    static let verticalSpacing: CGFloat = 8
    static let horizontalSpacing: CGFloat = 16
  }
  
  lazy var hStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fill
    stackView.alignment = .top
    stackView.spacing = 8
    return stackView
  }()
  
  lazy var vStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 8
    return stackView
  }()
  
  lazy var contentStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .bottom
    stackView.spacing = 0
    return stackView
  }()

  lazy var contentLabel: TFPaddingLabel = {
    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let label = TFPaddingLabel(padding: padding)
    label.backgroundColor = DSKitAsset.Color.primary500.color
    label.textColor = DSKitAsset.Color.neutral700.color
    label.font = UIFont.thtP2R
    label.numberOfLines = 0
    label.layer.cornerRadius = 12
    label.clipsToBounds = true
    label.lineBreakMode = .byWordWrapping
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
    self.contentView.backgroundColor = DSKitAsset.Color.neutral700.color
    contentLabel.textAlignment = .left
    dateLabel.textAlignment = .left
    self.contentView.addSubviews(hStackView, dateLabel)
    
    hStackView.addArrangedSubviews([vStackView])
    vStackView.addArrangedSubviews([ contentStackView])
    contentStackView.addArrangedSubviews([contentLabel])
    
    hStackView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(16)
      $0.top.equalToSuperview()
      $0.bottom.equalToSuperview().inset(8)
    }

    contentLabel.snp.makeConstraints {
      $0.height.greaterThanOrEqualTo(35)
      $0.width.lessThanOrEqualToSuperview()
    }

    dateLabel.snp.makeConstraints {
      $0.leading.equalTo(hStackView.snp.trailing).offset(8)
      $0.height.equalTo(20)
      $0.trailing.equalToSuperview().offset(Metric.verticalSpacing)
      $0.bottom.equalTo(hStackView)
    }
  }

  public func bind(reactor: BubbleReactor) {
    reactor.state.map(\.message)
      .bind(to: contentLabel.rx.text)
      .disposed(by: disposeBag)

      reactor.state.map(\.messageModel.message.dateTime)
          .map(DateFormatter.timeFormatter.string(from:))
      .bind(to: dateLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state.map(\.bubble)
      .withUnretained(self)
      .subscribe { owner, state in
        switch state {
        case .single:
          owner.dateLabel.isHidden = false
        case .head:
          owner.dateLabel.isHidden = true
        case .middle:
          owner.dateLabel.isHidden = true
        case .tail:
          owner.dateLabel.isHidden = false
        }
      }
      .disposed(by: disposeBag)
    
    setNeedsLayout()
    layoutIfNeeded()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let maxWidth = bounds.width * 0.6
    
    contentLabel.snp.remakeConstraints {
      $0.width.lessThanOrEqualTo(maxWidth)
      $0.height.greaterThanOrEqualTo(35)
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    contentLabel.text = nil
    dateLabel.text = nil
  }
}

