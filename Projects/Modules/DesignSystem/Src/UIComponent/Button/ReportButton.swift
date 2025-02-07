//
//  ReportButton.swift
//  DSKit
//
//  Created by Kanghos on 2/5/25.
//

import UIKit

extension UIButton {
 public static func createReportButton() -> UIButton {
    let button = UIButton()
    var config = UIButton.Configuration.plain()
    config.image = DSKitAsset.Image.Icons.reportFill.image.withTintColor(
      DSKitAsset.Color.neutral50.color,
      renderingMode: .alwaysOriginal
    )
    config.imagePlacement = .all
    config.baseBackgroundColor = DSKitAsset.Color.topicBackground.color
    button.configuration = config

    config.automaticallyUpdateForSelection = true
    return button
  }
}
