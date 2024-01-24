//
//  TFEmptyView.swift
//  DSKit
//
//  Created by Kanghos on 2024/01/11.
//

import UIKit

public class TFEmptyView: TFBaseView {
  private let image: UIImage
  private let title: String
  private let subTitle: String?
  private let buttonTitle: String

  private lazy var bxCardView = BXCardView(image: image, title: title, subTitle: subTitle)

  public lazy var button = WhiteStrokeMediumButton(title: buttonTitle)

  public init(image: UIImage, title: String, subTitle: String?, buttonTitle: String) {
    self.image = image
    self.title = title
    self.subTitle = subTitle
    self.buttonTitle = buttonTitle
    super.init(frame: .zero)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color
    
    self.addSubviews([bxCardView, button])

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
