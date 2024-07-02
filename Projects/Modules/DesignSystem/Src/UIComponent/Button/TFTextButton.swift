//
//  TFTextButton.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/13.
//

import UIKit

public final class TFTextButton: UIButton {
  public let title: String

  public init(title: String) {
    self.title = title
    super.init(frame: .zero)
    makeView(title: title)
  }

  public func makeView(title: String, font: UIFont = .thtP2M, color: UIColor = DSKitAsset.Color.neutral400.color) {
    let attributedString = NSMutableAttributedString(string: title)
    attributedString.addAttribute(.underlineStyle,
                                  value: NSUnderlineStyle.single.rawValue,
                                  range: NSRange(location: 0, length: title.count))

    attributedString.addAttribute(.font,
                                  value: font,
                                  range: NSRange(location: 0, length: title.count))

    attributedString.addAttribute(.underlineColor,
                                  value: color,
                                  range: NSRange(location: 0, length: title.count))

    attributedString.addAttribute(.foregroundColor,
                                  value: color,
                                  range: NSRange(location: 0, length: title.count))

    setAttributedTitle(attributedString, for: .normal)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
