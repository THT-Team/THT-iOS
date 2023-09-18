//
//  TFPaddingLabel.swift
//  Falling
//
//  Created by Kanghos on 2023/09/15.
//

import UIKit

final class TFPaddingLabel: UILabel {

  private static let defaultPadding = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
  private var padding: UIEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
  convenience init(padding: UIEdgeInsets? = nil) {
    self.init()

    self.padding = padding ?? Self.defaultPadding
  }

  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: padding))
  }

  override var intrinsicContentSize: CGSize {
    var contentSize = super.intrinsicContentSize
    contentSize.height += padding.top + padding.bottom
    contentSize.width += padding.left + padding.right

    return contentSize
  }
}
