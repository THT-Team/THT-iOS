//
//  CTAButton.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/26.
//

import UIKit
import RxSwift
import RxCocoa

final class CTAButton: UIButton {
	init(btnTitle: String, initialStatus: Bool) {
		super.init(frame: .zero)
		titleLabel?.font = .thtH5B
		setTitle(btnTitle, for: .normal)
		layer.cornerRadius = 16
		updateColors(status: initialStatus)
	}
	
	/// update CTA button color by status
	func updateColors(status: Bool) {
		if status {
			backgroundColor = FallingAsset.Color.primary500.color
			setTitleColor(FallingAsset.Color.neutral600.color, for: .normal)
		} else {
			backgroundColor = FallingAsset.Color.disabled.color
			setTitleColor(FallingAsset.Color.neutral900.color, for: .normal)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension Reactive where Base: CTAButton {
	var buttonStatus: Binder<Bool> {
		return Binder(base.self) { btn, status in
			btn.updateColors(status: status)
		}
	}
}
