//
//  UITextField+Util.swift
//  DSKit
//
//  Created by Kanghos on 7/22/24.
//

import UIKit

extension UITextField {
  func setPlaceholderColor(_ color: UIColor, font: UIFont) {
    guard let placeholder = self.placeholder else { return }
    self.attributedPlaceholder = NSAttributedString(
      string: placeholder,
      attributes: [
        NSAttributedString.Key.foregroundColor: color,
        .font: font
      ]
    )
  }
}
