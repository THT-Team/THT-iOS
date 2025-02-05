//
//  MatchViewController.swift
//  Falling
//
//  Created by Kanghos on 2/6/25.
//

import UIKit

import DSKit

final class MatchViewController: TFBaseViewController {

  var onClick: ((String) -> Void)?
  var onCancel: (() -> Void)?

  private let chatRoomIndex: String

  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  let titleLabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = .thtH2B
    label.textAlignment = .center
    label.text = "무디와 매칭되었어요!"
    return label
  }()

  let subTitleLabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = .thtSubTitle1Sb
    label.textAlignment = .center
    label.text = "대화를 시작해 서로를 알아가보세요"
    return label
  }()

  lazy var primaryButton = {
    let button = UIButton()
    var config = UIButton.Configuration.filled()

    config.cornerStyle = .fixed

    var titleAttribute = AttributedString("대화 시작하기")
    titleAttribute.font = UIFont.thtH5Sb
    titleAttribute.foregroundColor = DSKitAsset.Color.neutral600.color
    config.baseBackgroundColor = DSKitAsset.Color.primary500.color
    config.attributedTitle = titleAttribute
    config.background.cornerRadius = 16
    button.configuration = config
    button.addAction(.init(handler: { [weak self] _ in
      guard let self else { return }
      self.onClick?(self.chatRoomIndex)
    }), for: .touchUpInside)
    return button
  }()

  lazy var closeButton = {
    let button = UIButton()
    var config = UIButton.Configuration.filled()

    var titleAttribute = AttributedString("대화 시작하기")
    titleAttribute.font = UIFont.thtSubTitle2M
    titleAttribute.foregroundColor = DSKitAsset.Color.neutral50.color
    config.baseBackgroundColor = .clear
    config.attributedTitle = titleAttribute
    button.configuration = config
    button.addAction(.init(handler: { [weak self] _ in
      self?.onCancel?()
    }), for: .touchUpInside)
    return button
  }()

  init(_ imageURL: String, index: String) {
    self.chatRoomIndex = index
    super.init(nibName: nil, bundle: nil)

    bind(imageURL)
  }

  func bind(_ imageURL: String) {
    imageView.setImage(urlString: imageURL)
  }

  override func makeUI() {
    self.view.addSubviews(
      imageView,
      titleLabel,
      subTitleLabel,
      primaryButton,
      closeButton
    )

    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(172.f)
    }
    subTitleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom)
    }

    closeButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(39)
      $0.height.equalTo(30)
      $0.bottom.equalToSuperview().offset(-100)
    }

    primaryButton.snp.makeConstraints {
      $0.leading.trailing.equalTo(closeButton)
      $0.height.equalTo(80)
      $0.bottom.equalTo(closeButton.snp.top).offset(-16)
    }
  }
}
