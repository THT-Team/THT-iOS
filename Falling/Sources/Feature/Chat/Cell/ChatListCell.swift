//
//  ChatListCell.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import UIKit

import SnapKit
import RxSwift

final class ChatListTableViewCell: UITableViewCell {
  private var disposeBag = DisposeBag()

  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 12
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

  private let contentLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.thtP1R
    label.numberOfLines = 1
    label.textColor = FallingAsset.Color.neutral400.color
    return label
  }()

  private let dateTimeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.thtCaption1R
    label.numberOfLines = 1
    label.textColor = FallingAsset.Color.neutral300.color
    return label
  }()

  private let notiLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.thtCaption1Sb
    label.textColor = FallingAsset.Color.neutral700.color
    label.backgroundColor = FallingAsset.Color.primary500.color
    label.layer.cornerRadius = 9
    label.textAlignment = .center
    label.clipsToBounds = true
    return label
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func makeUI() {
    [profileImageView, nickNameLabel, dateTimeLabel, contentLabel, notiLabel].forEach {
      self.contentView.addSubview($0)
    }

    profileImageView.snp.makeConstraints {
      $0.size.equalTo(50)
      $0.top.bottom.equalToSuperview().inset(13)
      $0.leading.equalToSuperview().offset(16)
    }

    nickNameLabel.snp.makeConstraints {
      $0.bottom.equalTo(profileImageView.snp.centerY)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
    }
    dateTimeLabel.snp.makeConstraints {
      $0.leading.equalTo(nickNameLabel.snp.trailing)
      $0.trailing.equalToSuperview().inset(16)
      $0.top.equalTo(nickNameLabel)
    }
    contentLabel.snp.makeConstraints {
      $0.top.equalTo(nickNameLabel.snp.bottom)
      $0.leading.equalTo(nickNameLabel)
    }
    notiLabel.snp.makeConstraints {
      $0.leading.equalTo(contentLabel.snp.trailing).offset(12)
      $0.trailing.equalTo(dateTimeLabel)
      $0.top.equalTo(contentLabel)
      $0.size.equalTo(18)
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    profileImageView.image = nil
    nickNameLabel.text = nil
    dateTimeLabel.text = nil
    contentLabel.text = nil
    notiLabel.isHidden = true
  }

  func configure() {
    profileImageView.image = FallingAsset.Image.face.image
    nickNameLabel.text = "test"
    contentLabel.text = "내용 테스트"
    notiLabel.text = "1"
    dateTimeLabel.text = "08:24 PM"
    notiLabel.isHidden = false
  }
}
