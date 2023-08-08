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
