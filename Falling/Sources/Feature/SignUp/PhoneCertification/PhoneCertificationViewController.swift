//
//  PhoneCertificationViewController.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/03.
//

import UIKit

import SnapKit
import Then
import RxCocoa
import RxSwift
import RxKeyboard

final class PhoneCertificationViewController: TFBaseViewController {
	private lazy var titleLabel: UILabel = UILabel().then {
		$0.text = "핸드폰 번호 인증"
		$0.font = .thtH1B
		$0.textColor = FallingAsset.Color.netural50.color
	}
	
	private lazy var phoneNumTextField: UITextField = UITextField().then {
		$0.placeholder = "01012345678"
		$0.textColor = FallingAsset.Color.primary500.color
		$0.font = .thtH2B
		$0.keyboardType = .numberPad
	}
	
	private lazy var clearBtn: UIButton = UIButton().then {
		$0.setImage(FallingAsset.Image.closeCircle.image, for: .normal)
		$0.setTitle(nil, for: .normal)
		$0.backgroundColor = .clear
	}
	
	private lazy var divider: UIView = UIView().then {
		$0.backgroundColor = FallingAsset.Color.netural300.color
	}
	
	private lazy var infoImageView: UIImageView = UIImageView().then {
		$0.image = FallingAsset.Image.explain.image.withRenderingMode(.alwaysTemplate)
		$0.tintColor = FallingAsset.Color.netural400.color
	}
	
	private lazy var descLabel: UILabel = UILabel().then {
		$0.text = "핸드폰 번호 입력 시, 인증 코드를 문자 메세지로 발송합니다.\n핸드폰 번호는 다른 사람들에게 공유되거나 프로필에 표시하지 않습니다."
		$0.font = .thtCaption1M
		$0.textColor = FallingAsset.Color.netural400.color
		$0.textAlignment = .left
		$0.numberOfLines = 4
	}
	
	private lazy var verifyBtn: UIButton = UIButton().then {
		$0.setTitle("인증하기", for: .normal)
		$0.setTitleColor(FallingAsset.Color.netural600.color, for: .normal)
		$0.titleLabel?.font = .thtH5B
		$0.backgroundColor = FallingAsset.Color.primary500.color
		$0.layer.cornerRadius = 16
	}
	
	private let tapGesture = UITapGestureRecognizer()
	
	private let viewModel: PhoneCertificationViewModel
	
	init(viewModel: PhoneCertificationViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func makeUI() {
		[titleLabel, phoneNumTextField, clearBtn, divider, infoImageView, descLabel, verifyBtn].forEach {
			view.addSubview($0)
		}
		
		view.addGestureRecognizer(tapGesture)
		
		titleLabel.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide).inset(view.frame.height * 0.09)
			$0.leading.equalTo(view.safeAreaLayoutGuide).inset(38)
		}
		
		phoneNumTextField.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(32)
			$0.leading.equalTo(view.safeAreaLayoutGuide).inset(38)
			$0.trailing.equalTo(clearBtn.snp.trailing)
		}
		
		clearBtn.snp.makeConstraints {
			$0.centerY.equalTo(phoneNumTextField.snp.centerY)
			$0.width.height.equalTo(24)
			$0.trailing.equalTo(view.safeAreaLayoutGuide).inset(38)
		}
		
		divider.snp.makeConstraints {
			$0.leading.equalTo(phoneNumTextField.snp.leading)
			$0.trailing.equalTo(clearBtn.snp.trailing)
			$0.height.equalTo(2)
			$0.top.equalTo(phoneNumTextField.snp.bottom).offset(2)
		}
		
		infoImageView.snp.makeConstraints {
			$0.leading.equalTo(phoneNumTextField.snp.leading)
			$0.width.height.equalTo(16)
			$0.top.equalTo(divider.snp.bottom).offset(16)
		}
		
		descLabel.snp.makeConstraints {
			$0.leading.equalTo(infoImageView.snp.trailing).offset(6)
			$0.top.equalTo(divider.snp.bottom).offset(16)
			$0.trailing.equalTo(view.safeAreaLayoutGuide).inset(38)
		}
		
		verifyBtn.snp.makeConstraints {
			$0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(38)
			$0.bottom.equalTo(view.safeAreaLayoutGuide)
			$0.height.equalTo(54)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		keyBoardSetting()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		phoneNumTextField.becomeFirstResponder()
	}
	
	override func bindViewModel() {
		let input = PhoneCertificationViewModel.Input(
			phoneNum: phoneNumTextField.rx.text.orEmpty.asObservable(),
			clearBtn: clearBtn.rx.tap.asDriver(),
			verifyBtn: verifyBtn.rx.tap.asDriver()
		)
		
		let output = viewModel.transform(input: input)
		
		output.phoneNum.bind(to: phoneNumTextField.rx.text).disposed(by: disposeBag)
		
		output.validate.subscribe(
			onNext: { [weak self] result in
				guard let self else { return }
				self.verifyBtn.isEnabled = result
				if result {
					self.verifyBtn.backgroundColor = FallingAsset.Color.primary500.color
				} else {
					self.verifyBtn.backgroundColor = FallingAsset.Color.disabled.color
				}
			}
		)
		.disposed(by: disposeBag)
	}
	
	func keyBoardSetting() {
		tapGesture.rx.event
			.subscribe { [weak self] _ in
				guard let self else { return }
				self.view.endEditing(true)
			}
			.disposed(by: disposeBag)
		
		RxKeyboard.instance.visibleHeight
			.skip(1)
			.drive(onNext: { [weak self] keyboardHeight in
				guard let self else { return }
				self.verifyBtn.snp.updateConstraints {
					$0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight)
				}
			})
			.disposed(by: disposeBag)
	}

}
