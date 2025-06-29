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

final class OutgoingBubbleCell: BaseBubbleCell {
  
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
    contentLabel.textAlignment = .left
    dateLabel.textAlignment = .right
    self.profileImageView.isHidden = true
    self.nickNameLabel.isHidden = true
    self.spacer.isHidden = true
    
    self.contentView.addSubviews(dateLabel, hStackView)
    
    hStackView.addArrangedSubviews([profileImageView, spacer, vStackView])
    vStackView.addArrangedSubviews([ nickNameLabel, contentStackView])
    contentStackView.addArrangedSubviews([contentLabel])
    
    hStackView.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(16)
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
      $0.width.lessThanOrEqualTo(150)
    }

    dateLabel.snp.makeConstraints {
      $0.trailing.equalTo(hStackView.snp.leading).offset(-8)
      $0.height.equalTo(20)
      $0.leading.equalToSuperview().offset(Metric.verticalSpacing)
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

    reactor.state.map(\.dateText)
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

  override func prepareForReuse() {
    super.prepareForReuse()

    contentLabel.text = nil
    dateLabel.text = nil
    profileImageView.image = nil
    nickNameLabel.text = nil
  }
}
