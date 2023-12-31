//
//  BXCardView.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import UIKit
import Core
import SnapKit
import DSKit

class BXCardView: TFBaseView {
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
    label.textColor = DSKitAsset.Color.neutral50.color
    return label
  }()

  private lazy var subTitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.textAlignment = .center
    label.font = UIFont.thtP1R
    label.text = subTitle
    label.textColor = DSKitAsset.Color.neutral300.color
    return label
  }()

  init(image: UIImage, title: String, subTitle: String?) {
    self.image = image
    self.title = title
    self.subTitle = subTitle
    super.init(frame: .zero)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func makeUI() {
    self.addSubview(stackView)
    stackView.addArrangedSubviews([imageView, titleLabel, subTitleLabel])
    
    stackView.setCustomSpacing(CGFloat(CardSapcing.viewOnTop.rawValue), after: imageView)
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    self.imageView.image = self.image
  }
}

