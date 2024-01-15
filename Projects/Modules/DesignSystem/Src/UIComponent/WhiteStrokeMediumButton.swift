//
//  WhiteStrokeButtonMedium.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import UIKit

public class WhiteStrokeMediumButton: UIButton {
  public init(title: String?) {
    super.init(frame: .zero)

    var config = UIButton.Configuration.filled()

    config.baseBackgroundColor = DSKitAsset.Color.neutral700.color

    config.background.strokeColor = DSKitAsset.Color.neutral50.color
    config.background.strokeWidth = 1
    config.background.cornerRadius = 16

    var attributedTitle = AttributedString(stringLiteral: title ?? "")
    attributedTitle.foregroundColor = DSKitAsset.Color.neutral50.color
    attributedTitle.font = .thtH5B
    config.attributedTitle = attributedTitle

    self.configuration = config
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
