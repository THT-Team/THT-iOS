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

import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class HeartCollectionViewCell: UICollectionViewListCell {
  var disposeBag = DisposeBag()

  private var model: Like?

  private var indexPath: IndexPath? {
    guard let collectionView = self.superview as? UICollectionView,
          let indexPath = collectionView.indexPath(for: self) else {
      TFLogger.ui.error("indexPath 얻기 실패")
      return nil
    }
    return indexPath
  }

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

  private lazy var nextTimeButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.filled()

    config.image = DSKitAsset.Image.Icons.face.image.withTintColor(DSKitAsset.Color.neutral50.color, renderingMode: .alwaysOriginal)
    config.imagePadding = 10
    config.imagePlacement = .leading
    config.cornerStyle = .capsule

    var titleAttribute = AttributedString("다음에")
    titleAttribute.font = UIFont.thtSubTitle2Sb
    titleAttribute.foregroundColor = DSKitAsset.Color.neutral50.color
    config.baseBackgroundColor = DSKitAsset.Color.neutral600.color
    config.attributedTitle = titleAttribute
    config.background.strokeWidth = 1
    config.background.strokeColor = DSKitAsset.Color.neutral400.color

    button.configuration = config

    return button
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 16
    return stackView
  }()

  private lazy var chatButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.filled()

    config.image = DSKitAsset.Image.Icons.messageSquare1.image.withTintColor(DSKitAsset.Color.neutral700.color, renderingMode: .alwaysOriginal)
    config.imagePadding = 10
    config.imagePlacement = .leading
    config.cornerStyle = .capsule

    var titleAttribute = AttributedString("대화히기")
    titleAttribute.font = UIFont.thtSubTitle2Sb
    titleAttribute.foregroundColor = DSKitAsset.Color.neutral700.color
    config.baseBackgroundColor = DSKitAsset.Color.primary500.color
    config.attributedTitle = titleAttribute

    button.configuration = config

    return button
  }()

  private let newArriavalView: UIView = {
    let view = UIView()
    view.backgroundColor = DSKitAsset.Color.error.color
    view.layer.cornerRadius = 3
    view.clipsToBounds = true
    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: .zero)
    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }



  func makeUI() {
    self.contentView.backgroundColor = DSKitAsset.Color.neutral600.color
    self.contentView.layer.cornerRadius = 12

    [profileImageView, nickNameLabel, locationIconImageView, locationLabel,
     newArriavalView, stackView
    ].forEach {
      self.contentView.addSubview($0)
    }

    [nextTimeButton, chatButton].forEach {
      stackView.addArrangedSubview($0)

    }

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
      $0.trailing.bottom.equalToSuperview().inset(12)
      $0.height.equalTo((UIScreen.main.bounds.width - 14 * 2) * 33 / 358)
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
    self.disposeBag = DisposeBag()
    profileImageView.image = nil
    nickNameLabel.text = nil
    locationLabel.text = nil
  }

  func bind(viewModel: Like) {
    self.model = viewModel
    profileImageView.image = nil
    nickNameLabel.text = viewModel.username
    locationLabel.text = viewModel.address
  }

  func bind<O>(_ observer: O, index: IndexPath) where O: ObserverType, O.Element == ( LikeCellButtonAction) {

    nextTimeButton.rx.tap
      .debug()
      .map {
        guard let collectionView = self.superview as? UICollectionView else {
          TFLogger.ui.error("변환 실패")
          return IndexPath(row: 0, section: 0)
        }
        guard let indexPath = collectionView.indexPath(for: self) else {
          TFLogger.ui.error("indexPath 얻기 실패")
          return IndexPath(row: 0, section: 0)
        }
        return indexPath
      }
      .map { LikeCellButtonAction.reject($0) }
      .bind(to: observer)
      .disposed(by: disposeBag)

    chatButton.rx.tap
      .compactMap { self.indexPath }
      .map { LikeCellButtonAction.chat($0) }
      .bind(to: observer)
      .disposed(by: disposeBag)

    profileImageView.rx.tapGesture()
      .when(.recognized).mapToVoid()
      .compactMap { self.indexPath }
      .map { LikeCellButtonAction.profile($0) }
      .bind(to: observer)
      .disposed(by: disposeBag)
  }
}
