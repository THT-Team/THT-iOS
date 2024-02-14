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
}
