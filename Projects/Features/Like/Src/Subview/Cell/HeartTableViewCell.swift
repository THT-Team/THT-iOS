//
//  HeartListCell.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import UIKit

import Core
import DSKit
import LikeInterface

final class HeartCollectionViewCell: TFBaseCollectionViewCell {

  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 10
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = DSKitAsset.Color.primary300.color
    return imageView
  }()

  private let nickNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.thtSubTitle2M
    label.numberOfLines = 1
    label.textColor = DSKitAsset.Color.neutral50.color
    return label
  }()
	
  private lazy var locationIconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = DSKitAsset.Image.Icons.pinSmall.image.withTintColor(DSKitAsset.Color.neutral400.color, renderingMode: .alwaysOriginal)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private let locationLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.thtP2R
    label.numberOfLines = 1
    label.textColor = DSKitAsset.Color.neutral400.color

    return label
  }()

  private lazy var chatButton = UIButton.chat()
  private lazy var nextTimeButton = UIButton.nextTime()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 16
    return stackView
  }()

  private let newArriavalView: UIView = {
    let view = UIView()
    view.backgroundColor = DSKitAsset.Color.error.color
    view.layer.cornerRadius = 3
    view.clipsToBounds = true
    return view
  }()


  override func makeUI() {
		self.backgroundView = UIView().then {
			$0.backgroundColor = DSKitAsset.Color.neutral700.color
		}
		
    self.contentView.backgroundColor = DSKitAsset.Color.neutral600.color
    self.contentView.layer.cornerRadius = 12

		contentView.addSubviews(
			profileImageView, 
			nickNameLabel,
			locationIconImageView,
			locationLabel,
			newArriavalView,
			stackView
		)

    stackView.addArrangedSubview(nextTimeButton)
    stackView.addArrangedSubview(chatButton)

    profileImageView.snp.makeConstraints {
      $0.width.equalTo((UIScreen.main.bounds.width - 14 * 2) * 84 / 358)
      $0.top.bottom.equalToSuperview().inset(12)
      $0.leading.equalToSuperview().offset(12)
    }

    nickNameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(14)
    }
		
    locationIconImageView.snp.makeConstraints {
      $0.leading.equalTo(nickNameLabel)
      $0.top.equalTo(nickNameLabel.snp.bottom).offset(3)
    }
		
    locationLabel.snp.makeConstraints {
      $0.centerY.equalTo(locationIconImageView)
      $0.leading.equalTo(locationIconImageView.snp.trailing)
    }

    stackView.snp.makeConstraints {
      $0.top.equalTo(locationIconImageView.snp.bottom).offset(10)
      $0.leading.equalTo(nickNameLabel)
      $0.trailing.equalToSuperview().offset(-12)
      $0.height.equalTo((UIScreen.main.bounds.width - 14 * 2) * 33 / 358)
      $0.bottom.equalToSuperview().offset(-12)
    }

    newArriavalView.snp.makeConstraints {
      $0.top.equalTo(profileImageView)
      $0.leading.equalTo(nickNameLabel.snp.trailing)
      $0.trailing.equalToSuperview().inset(12)
      $0.size.equalTo(6)
    }
  }

  override func prepareForReuse() {
    profileImageView.image = nil
    nickNameLabel.text = nil
    locationLabel.text = nil
    super.prepareForReuse()
  }

  func bind<O>(_ observer: O, like: Like) where O: ObserverType, O.Element == ( LikeCellButtonAction) {
    profileImageView.kf.setImage(with: URL(string: like.profileURL)!)
    nickNameLabel.text = like.username
    locationLabel.text = like.address

    nextTimeButton.rx.tap
      .map { LikeCellButtonAction.reject(like) }
      .bind(to: observer)
      .disposed(by: disposeBag)

    chatButton.rx.tap
      .map { LikeCellButtonAction.chat(like) }
      .bind(to: observer)
      .disposed(by: disposeBag)

    profileImageView.rx.tapGesture()
      .when(.recognized).mapToVoid()
      .map { LikeCellButtonAction.profile(like) }
      .bind(to: observer)
      .disposed(by: disposeBag)
  }
}


fileprivate extension UIButton {
  static func nextTime() -> UIButton {
    let button = UIButton()
    var config = UIButton.Configuration.filled()

    config.cornerStyle = .capsule

    var titleAttribute = AttributedString("다음에")
    titleAttribute.font = UIFont.thtSubTitle2M
    titleAttribute.foregroundColor = DSKitAsset.Color.neutral300.color
    config.baseBackgroundColor = DSKitAsset.Color.neutral500.color
    config.attributedTitle = titleAttribute

    button.configuration = config

    return button
  }

  static func chat() -> UIButton {
    let button = UIButton()
    var config = UIButton.Configuration.filled()

    config.cornerStyle = .capsule

    var titleAttribute = AttributedString("대화히기")
    titleAttribute.font = UIFont.thtSubTitle2M
    titleAttribute.foregroundColor = DSKitAsset.Color.neutral700.color
    config.baseBackgroundColor = DSKitAsset.Color.primary500.color
    config.attributedTitle = titleAttribute

    config.background.strokeWidth = 1
    config.background.strokeColor = DSKitAsset.Color.neutral300.color

    button.configuration = config

    return button
  }
}
