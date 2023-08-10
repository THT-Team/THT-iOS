//
//  BXCardView.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import UIKit

import SnapKit

class BXCardView: UIView {
  // TODO: BXCard Type 정의 title, subtitle, image 후 주입
  enum CardSapcing: Int {
    case smallOnTop = 32
    case bigOnTop = 40
    case viewOnTop = 24
  }

  private let image: UIImage
  private let title: String
  private let subTitle: String?

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .fill
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.spacing = 16
    return stackView
  }()

  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = UIFont.thtH4Sb
    label.textAlignment = .center
    label.text = title
    label.textColor = FallingAsset.Color.neutral50.color
    return label
  }()

  private lazy var subTitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.textAlignment = .center
    label.font = UIFont.thtP1R
    label.text = subTitle
    label.textColor = FallingAsset.Color.neutral300.color
    return label
  }()

  init(image: UIImage, title: String, subTitle: String?) {
    self.image = image
    self.title = title
    self.subTitle = subTitle
    super.init(frame: .zero)

    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func makeUI() {
    self.addSubview(stackView)
    [imageView, titleLabel, subTitleLabel].forEach {
      stackView.addArrangedSubview($0)
    }
    stackView.setCustomSpacing(CGFloat(CardSapcing.viewOnTop.rawValue), after: imageView)
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    self.imageView.image = self.image
  }
}

