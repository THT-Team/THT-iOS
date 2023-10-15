//
//  UIViewController+Extension.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/06.
//

import SwiftUI

#if DEBUG
extension UIViewController {
	private struct Preview: UIViewControllerRepresentable {
		let viewController: UIViewController
		
		func makeUIViewController(context: Context) -> UIViewController {
			return viewController
		}
		
		func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
	}
	
	func toPreView() -> some View {
		Preview(viewController: self)
	}
}
#endif

#if canImport(SwiftUI) && DEBUG
		import SwiftUI

		public struct UIViewPreview<View: UIView>: UIViewRepresentable {
				public let view: View
				public init(_ builder: @escaping () -> View) {
						view = builder()
				}
				// MARK: - UIViewRepresentable
				public func makeUIView(context: Context) -> UIView {
						return view
				}
				public func updateUIView(_ view: UIView, context: Context) {
						view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
						view.setContentHuggingPriority(.defaultHigh, for: .vertical)
				}
		}
#endif
