//
//  BXComponent.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import UIKit

import SnapKit

class TFEmptyView: UIView {
  private let image: UIImage
  private let title: String
  private let subTitle: String?
  private let buttonTitle: String

  private lazy var bxCardView: BXCardView = {
    let cardView = BXCardView(image: image, title: title, subTitle: subTitle)
    return cardView
  }()

  lazy var button: WhiteStrokeMediumButton = {
    let button = WhiteStrokeMediumButton(title: buttonTitle)

    return button
  }()

  init(image: UIImage, title: String, subTitle: String?, buttonTitle: String) {
    self.image = image
    self.title = title
    self.subTitle = subTitle
    self.buttonTitle = buttonTitle
    super.init(frame: .zero)

    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func makeUI() {
    self.addSubview(bxCardView)
    self.addSubview(button)

    self.backgroundColor = FallingAsset.Color.neutral700.color
    bxCardView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-54)
    }

    button.snp.makeConstraints {
      $0.top.equalTo(bxCardView.snp.bottom).offset(64)
      $0.leading.trailing.equalTo(bxCardView)
      $0.height.equalTo(54)
    }
  }
}
