//
//  EmailInputViewController.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/06.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard
import Then
import SnapKit

class EmailInputViewController: TFBaseViewController {
		
	private let viewModel: EmailInputViewModel
	
	init(viewModel: EmailInputViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
			
	}
	
	override func makeUI() {
		
	}
	
	override func bindViewModel() {
		let input = EmailInputViewModel.Input()
		let output = viewModel.transform(input: input)
		
		
	}
}
