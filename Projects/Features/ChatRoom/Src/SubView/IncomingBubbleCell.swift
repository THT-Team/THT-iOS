//
//  ChatBubbleCell.swift
//  Chat
//
//  Created by Kanghos on 2024/01/14.
//

import UIKit

import DSKit
import Domain
import ReactorKit

final class IncomingBubbleCell: BaseBubbleCell {
  
  lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 12
    imageView.clipsToBounds = true
    return imageView
  }()

  lazy var nickNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral300.color
    label.font = UIFont.thtP2R
    label.numberOfLines = 1
    return label
  }()
  
  
  lazy var spacer: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }()

  override func makeUI() {
    self.contentView.backgroundColor = DSKitAsset.Color.neutral700.color
    contentLabel.backgroundColor = DSKitAsset.Color.neutral600.color
    contentLabel.textColor = DSKitAsset.Color.neutral50.color
    contentLabel.textAlignment = .left
    dateLabel.textAlignment = .left
    
    self.contentView.addSubviews(hStackView, dateLabel)
    
    hStackView.addArrangedSubviews([profileImageView, spacer, vStackView])
    vStackView.addArrangedSubviews([ nickNameLabel, contentStackView])
    contentStackView.addArrangedSubviews([contentLabel])
    
    hStackView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(16)
      $0.top.equalToSuperview()
      $0.bottom.equalToSuperview().inset(8)
    }

    profileImageView.snp.makeConstraints {
      $0.size.equalTo(50)
    }
    
    spacer.snp.makeConstraints {
      $0.height.equalTo(35)
      $0.width.equalTo(50)
    }

    nickNameLabel.snp.makeConstraints {
      $0.height.equalTo(20)
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

  override func bind(reactor: BubbleReactor) {
    profileImageView.rx.tapGesture()
      .when(.recognized)
      .map { _ in Reactor.Action.profileTap }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    reactor.state.map(\.message)
      .bind(to: contentLabel.rx.text)
      .disposed(by: disposeBag)

      reactor.state.map(\.messageModel.message.dateTime)
          .map(DateFormatter.timeFormatter.string(from:))
      .bind(to: dateLabel.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map(\.sender)
      .bind(to: nickNameLabel.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map(\.imageURL)
      .subscribe(with: self) { owner, imageURL in
        owner.profileImageView.setImage(urlString: imageURL)
      }
      .disposed(by: disposeBag)
    
    reactor.state.map(\.bubble)
      .withUnretained(self)
      .subscribe { owner, state in
        switch state {
        case .single:
          owner.profileImageView.isHidden = false
          owner.spacer.isHidden = true
          owner.dateLabel.isHidden = false
          owner.nickNameLabel.isHidden = false
        case .head:
          owner.profileImageView.isHidden = false
          owner.spacer.isHidden = true
          owner.dateLabel.isHidden = true
          owner.nickNameLabel.isHidden = false
        case .middle:
          owner.profileImageView.isHidden = true
          owner.spacer.isHidden = false
          owner.dateLabel.isHidden = true
          owner.nickNameLabel.isHidden = true
        case .tail:
          owner.profileImageView.isHidden = true
          owner.spacer.isHidden = false
          owner.dateLabel.isHidden = false
          owner.nickNameLabel.isHidden = true
        }
      }
      .disposed(by: disposeBag)

    setNeedsLayout()
    layoutIfNeeded()
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    contentLabel.text = nil
    dateLabel.text = nil
    profileImageView.image = nil
    nickNameLabel.text = nil
  }
}
