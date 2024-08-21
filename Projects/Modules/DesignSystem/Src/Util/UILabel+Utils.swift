//
//  UILabel+Utils.swift
//  DSKit
//
//  Created by SeungMin on 2/11/24.
//

import UIKit

extension UILabel {
  public func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
    if let text = text {
      let style = NSMutableParagraphStyle()
      style.alignment = .center
      style.maximumLineHeight = lineHeight
      style.minimumLineHeight = lineHeight
      
      let attributes: [NSAttributedString.Key: Any] = [
        .paragraphStyle: style,
        .baselineOffset: (lineHeight - font.lineHeight) / 2
      ]
      
      let attrString = NSAttributedString(string: text,
                                          attributes: attributes)
      self.attributedText = attrString
    }
  }

  public func setTextWithLetterSpacing(text: String?, letterSpacing: CGFloat) {
    if let text = text {
      let attributedString = NSMutableAttributedString(string: text)
      attributedString.addAttribute(
        .kern,
        value: letterSpacing/100 * font.pointSize,
        range: NSRange(location: 0, length: attributedString.length))
      self.attributedText = attributedString
    }
  }

  public func setTextWithLineSpacing(text: String?, lineSpacing: CGFloat) {
    if let text = text {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = lineSpacing * font.pointSize
      paragraphStyle.alignment = .center

      let attributedString = NSMutableAttributedString(string: text)
      attributedString.addAttribute(
        .paragraphStyle, 
        value: paragraphStyle,
        range: NSRange(location: 0, length: attributedString.length))

      self.attributedText = attributedString
    }
  }

  public static func setH4TargetBold(text: String, target: String) -> UILabel {
    setTargetBold(text: text, target: target, font: .thtH4M, targetFont: .thtH4B)
  }

  public static func setH1TargetBold(text: String, target: String) -> UILabel {
    setTargetBold(text: text, target: target, font: .thtH1M, targetFont: .thtH1B)
  }

  public static func setTargetBold(text: String, target: String, font: UIFont, targetFont: UIFont) -> UILabel {
    return UILabel().then {
      $0.text = text
      $0.textColor = DSKitAsset.Color.neutral400.color
      $0.asColor(targetString: target, color: DSKitAsset.Color.neutral50.color)
      $0.asFont(targetString: target, font: targetFont)
      $0.font = font
    }
  }
}
