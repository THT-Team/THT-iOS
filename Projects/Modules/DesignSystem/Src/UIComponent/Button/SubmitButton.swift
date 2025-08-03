//
//  SubmitButton.swift
//  DSKit
//
//  Created by SeungMin on 8/3/25.
//

import UIKit

public final class SubmitButton: UIButton {
  
  private var action: (() -> Void)?
  
  // MARK: - Convenience Initializer
  public convenience init(
    title: String,
    foreground: UIColor = DSKitAsset.Color.neutral600.color,
    background: UIColor = DSKitAsset.Color.primary500.color,
    font: UIFont = UIFont.thtH5B,
    cornerRadius: CGFloat = 16,
    action: @escaping () -> Void
  ) {
    self.init(frame: .zero)
    self.action = action
    configuration = Self.makeConfig(
      title: title,
      foregroundColor: foreground,
      backgroundColor: background,
      font: font,
      cornerRadius: cornerRadius
    )
    addAction(UIAction { _ in action() }, for: .touchUpInside)
  }
}

// MARK: - Private Helper
private extension SubmitButton {
  static func makeConfig(
    title: String,
    foregroundColor: UIColor,
    backgroundColor: UIColor,
    font: UIFont,
    cornerRadius: CGFloat
  ) -> UIButton.Configuration {
    var config = UIButton.Configuration.filled()
    config.title                 = title
    config.baseForegroundColor   = foregroundColor
    config.baseBackgroundColor   = backgroundColor
    
    var titleAttribute = AttributedString(title)
    titleAttribute.font = font
    titleAttribute.foregroundColor = foregroundColor
    config.attributedTitle = titleAttribute
    
    config.cornerStyle = .fixed
    config.background.cornerRadius = cornerRadius
    return config
  }
}
