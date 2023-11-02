//
//  UIButton+Util.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 10/29/23.
//

import UIKit

extension UIButton {
	func toClearBtn() -> UIButton {
		self.setImage(FallingAsset.Image.closeCircle.image, for: .normal)
		self.setTitle(nil, for: .normal)
		self.backgroundColor = .clear
		
		return self
	}
}
