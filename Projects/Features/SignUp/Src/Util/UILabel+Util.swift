//
//  UIFont+Util.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/16.
//

import UIKit
import DSKit

extension UILabel {
  @discardableResult
  func asColor(targetString: String, color: UIColor) -> Self {
    let fullText = self.text ?? ""
    let range = (fullText as NSString).range(of: targetString)
    var mutable: NSMutableAttributedString

    if let attributed = self.attributedText {
      mutable = NSMutableAttributedString(attributedString: attributed)
    } else {
      mutable = NSMutableAttributedString(string: fullText)
    }
    mutable.addAttributes([.foregroundColor: color], range: range)
    self.attributedText = mutable
    return self
  }

  @discardableResult
  func asFont(targetString: String, font: UIFont) -> Self {
    let fullText = self.text ?? ""
    let range = (fullText as NSString).range(of: targetString)

    var mutable: NSMutableAttributedString

    if let attributed = self.attributedText {
      mutable = NSMutableAttributedString(attributedString: attributed)
    } else {
      mutable = NSMutableAttributedString(string: fullText)
    }
    mutable.addAttribute(.font, value: font, range: range)
    self.attributedText = mutable

    return self
  }
}
