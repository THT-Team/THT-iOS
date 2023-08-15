//
//  HeartListCell.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import UIKit

import SnapKit
import RxSwift

final class HeartListTableViewCell: UITableViewCell {
  private var disposeBag = DisposeBag()

  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 10
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private let nickNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.thtSubTitle2M
    label.numberOfLines = 1
    label.textColor = FallingAsset.Color.neutral50.color
    return label
  }()
  private lazy var locationIconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = FallingAsset.Image.pinSmall.image.withRenderingMode(.alwaysOriginal)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private let locationLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.thtP2R
    label.numberOfLines = 1
    label.textColor = FallingAsset.Color.neutral400.color

    return label
  }()

  private lazy var nextTimeButton: UIButton = {
    let button = UIButton()
    button.setTitle("다음에", for: .normal)
    button.setTitleColor(FallingAsset.Color.neutral50.color, for: .normal)
    button.setImage(FallingAsset.Image.face.image, for: .normal)
    button.backgroundColor = .clear
    button.layer.borderColor = FallingAsset.Color.neutral400.color.cgColor
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 16
    button.layer.masksToBounds = true
    return button
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    return stackView
  }()

  private lazy var chatButton: UIButton = {
    let button = UIButton()
    button.setTitle("대화하기", for: .normal)
    button.setTitleColor(FallingAsset.Color.neutral700.color, for: .normal)
    button.setImage(FallingAsset.Image.messageSquare.image, for: .normal)
    button.backgroundColor = FallingAsset.Color.primary500.color
    button.layer.cornerRadius = 16
    button.layer.masksToBounds = true
    return button
  }()

  private let newArriavalView: UIView = {
    let view = UIView()
    view.backgroundColor = FallingAsset.Color.error.color
    view.layer.cornerRadius = 3
    view.clipsToBounds = true
    return view
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func makeUI() {
    [profileImageView, nickNameLabel, locationIconImageView, locationLabel,
     newArriavalView, stackView
    ].forEach {
      self.contentView.addSubview($0)
    }

    [nextTimeButton, chatButton].forEach {
      stackView.addArrangedSubview($0)
      $0.snp.makeConstraints {
        $0.height.equalTo(33)
      }
    }

    profileImageView.snp.makeConstraints {
      $0.size.equalTo(84)
      $0.top.bottom.equalToSuperview().inset(12)
      $0.leading.equalToSuperview().offset(12)
    }

    nickNameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
    }
    locationIconImageView.snp.makeConstraints {
      $0.leading.equalTo(nickNameLabel)
      $0.top.equalTo(nickNameLabel.snp.bottom)
    }
    locationLabel.snp.makeConstraints {
      $0.top.equalTo(locationIconImageView)
      $0.leading.equalTo(locationIconImageView.snp.trailing)
    }

    stackView.snp.makeConstraints {
      $0.leading.equalTo(nickNameLabel)
      $0.trailing.bottom.equalToSuperview().inset(12)
      $0.height.equalTo(33)
    }

    newArriavalView.snp.makeConstraints {
      $0.top.equalTo(profileImageView)
      $0.leading.equalTo(nickNameLabel.snp.trailing)
      $0.trailing.equalToSuperview().inset(12)
      $0.size.equalTo(6)
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    profileImageView.image = nil
    nickNameLabel.text = nil
  }

  func configure() {
    profileImageView.image = FallingAsset.Image.face.image
    nickNameLabel.text = "우리닉네임열두글자입니다, 24"
    locationLabel.text = "서울시 강남구 대치동"
  }
}
