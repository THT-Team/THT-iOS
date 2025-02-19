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

  lazy var hStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 8
    return stackView
  }()

  lazy var nickNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral300.color
    label.font = UIFont.thtP2R
    label.numberOfLines = 1
    return label
  }()

  override func makeUI() {
    self.contentView.addSubviews(profileImageView, hStackView, dateLabel)
    self.contentView.backgroundColor = DSKitAsset.Color.neutral700.color
    hStackView.addArrangedSubviews([ nickNameLabel, contentLabel])

    contentLabel.backgroundColor = DSKitAsset.Color.neutral600.color
    contentLabel.textColor = DSKitAsset.Color.neutral50.color
    contentLabel.textAlignment = .center
    dateLabel.textAlignment = .left

    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(13)
      $0.leading.equalToSuperview().offset(16)
      $0.size.equalTo(50)
    }

    hStackView.snp.makeConstraints {
      $0.top.equalTo(profileImageView)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
      $0.bottom.equalToSuperview().offset(-13)
    }

    nickNameLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }

    contentLabel.snp.makeConstraints {
      $0.height.greaterThanOrEqualTo(35)
    }

    dateLabel.snp.makeConstraints {
      $0.leading.equalTo(hStackView.snp.trailing).offset(8)
      $0.height.equalTo(20)
      $0.trailing.equalToSuperview()
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
