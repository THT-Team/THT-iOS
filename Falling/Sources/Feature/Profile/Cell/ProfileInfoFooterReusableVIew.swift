//
//  ProfileInfoFooterReusableVIew.swift
//  Falling
//
//  Created by Kanghos on 2023/09/17.
//

import UIKit

import SnapKit
import RxSwift

final class ProfileInfoReusableView: UICollectionReusableView {
  var disposeBag = DisposeBag()
  private lazy var sections: [profileInfoSection] = [] {
    didSet {
      DispatchQueue.main.async {
        self.tagCollectionView.sections = self.sections
      }
    }
  }
  lazy var reportButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.plain()
    config.image = FallingAsset.Image.reportFill.image.withTintColor(
      FallingAsset.Color.neutral50.color,
      renderingMode: .alwaysOriginal
    )
    config.imagePlacement = .all
    config.baseBackgroundColor = FallingAsset.Color.topicBackground.color
    button.configuration = config

    config.automaticallyUpdateForSelection = true
    return button
  }()

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "최지인"
    label.font = UIFont.thtH1B
    return label
  }()

  private lazy var pinImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = FallingAsset.Image.pinSmall.image
    return imageView
  }()
  private lazy var addressLabel: UILabel = {
    let label = UILabel()
    label.textColor = FallingAsset.Color.neutral50.color
    label.font = UIFont.thtP2R
    return label
  }()
  private lazy var hStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.addArrangedSubviews([pinImageView, addressLabel])
    stackView.axis = .horizontal
    return stackView
  }()
  private lazy var vStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.addArrangedSubviews([titleLabel, hStackView])
    stackView.axis = .vertical
    stackView.alignment = .leading
    return stackView
  }()

  private lazy var tagCollectionView = TagCollectionView()

  override init(frame: CGRect) {
    super.init(frame: .zero)

    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func makeUI() {
    self.addSubviews([vStackView, tagCollectionView])

    vStackView.snp.makeConstraints {
      $0.leading.top.equalToSuperview().offset(15)
    }
    tagCollectionView.snp.makeConstraints {
      $0.top.equalTo(vStackView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    disposeBag = DisposeBag()
  }

  func configure(info: HeartUserResponse) {
    TFLogger.view.debug("\(info.username)")
    self.titleLabel.text = info.description
    self.addressLabel.text = info.address
    self.sections = [
      profileInfoSection(header: "이상형", items: info.idealTypeList.map { $0.toDomain() }),
      profileInfoSection(header: "흥미", items: info.interestsList.map { $0.toDomain() }),
      profileInfoSection(header: "자기소개", introduce: info.introduction)
    ]
  }
}
