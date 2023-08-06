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
	// MARK: Test Code
	private lazy var validationCodeLabel: UILabel = UILabel().then {
		$0.font = .thtH1B
		$0.textColor = .white
	}
	
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
		view.addSubview(validationCodeLabel)
		validationCodeLabel.snp.makeConstraints {
			$0.center.equalToSuperview()
			$0.height.equalTo(60)
		}
	}
	
	override func bindViewModel() {
		let input = PhoneValidationViewModel.Input()
		let output = viewModel.transform(input: input)
		
		output.validationCode
			.bind(to: validationCodeLabel.rx.text)
			.disposed(by: disposeBag)
	}
}
