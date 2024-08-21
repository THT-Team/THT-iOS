//
//  UIFont+Util.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/16.
//

import UIKit

extension UILabel {
  @discardableResult
  public func asColor(targetString: String, color: UIColor) -> Self {
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
  public func asFont(targetString: String, font: UIFont) -> Self {
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

extension String {
  public func asFont(target: String, font: UIFont) -> NSAttributedString {
    let fullText = self
    let range = (fullText as NSString).range(of: target)
    var mutable = NSMutableAttributedString(string: fullText)
    mutable.addAttribute(.font, value: font, range: range)
    return mutable
  }
}
