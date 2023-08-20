//
//  PhoneValidationViewController.swift
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

class PhoneValidationViewController: TFBaseViewController {
		
	private let viewModel: PhoneValidationViewModel
	
	init(viewModel: PhoneValidationViewModel) {
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
		let input = PhoneValidationViewModel.Input()
		let output = viewModel.transform(input: input)
		
		
	}
}
