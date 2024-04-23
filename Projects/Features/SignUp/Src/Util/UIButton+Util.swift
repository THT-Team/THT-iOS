//
//  UIButton+Util.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit

import DSKit

extension UIButton {
  static var plusButton: UIButton {
    let button = UIButton()
    var config = UIButton.Configuration.filled()

    config.baseBackgroundColor = DSKitAsset.Color.disabled.color
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 10)
    config.image = UIImage(systemName: "plus", withConfiguration: imageConfig)?.withTintColor(DSKitAsset.Color.neutral50.color, renderingMode: .alwaysOriginal)
    config.imagePadding = 14
    config.cornerStyle = .capsule

    button.configuration = config

    return button
  }
}
