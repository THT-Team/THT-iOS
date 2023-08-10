//
//  WhiteStrokeButtonMedium.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import UIKit

class WhiteStrokeMediumButton: UIButton {
  init(title: String?) {
    super.init(frame: .zero)

    setTitle(title, for: .normal)
    setTitleColor(FallingAsset.Color.neutral50.color, for: .normal)
    titleLabel?.font = UIFont.thtH5B
    backgroundColor = .clear
    self.layer.cornerCurve = .continuous
    self.layer.cornerRadius = 16
    self.layer.borderWidth = 1
    self.layer.borderColor = FallingAsset.Color.neutral50.color.cgColor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
