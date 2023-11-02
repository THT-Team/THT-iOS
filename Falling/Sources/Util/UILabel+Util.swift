//
//  UILabel+Util.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 10/22/23.
//

import UIKit

extension UILabel {
	func differentTextColor(labelText: String?, rangeText: String, color: UIColor) {
		guard  let labelText = labelText else { return }
		let attributedText = NSMutableAttributedString(string: labelText)
		let range = (labelText as NSString).range(of: rangeText)
		attributedText.addAttribute(.foregroundColor, value: color, range: range)
		self.attributedText = attributedText
	}
}
