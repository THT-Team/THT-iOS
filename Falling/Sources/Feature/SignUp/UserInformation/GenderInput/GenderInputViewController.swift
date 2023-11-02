//
//  GenderInputViewController.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 10/29/23.
//

import UIKit

final class GenderInputViewController: TFBaseViewController {
	private let viewModel: GenderInputViewModel
	
	init(viewModel: GenderInputViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	override func bindViewModel() {
		let input = GenderInputViewModel.Input(
			viewWillAppear: rx.viewWillAppear.mapToVoid().asDriverOnErrorJustEmpty()
		)
		
		let output = viewModel.transform(input: input)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
