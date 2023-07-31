//
//  SignUpRootViewController.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/07/16.
//

import UIKit

import RxSwift
import RxKeyboard

final class SignUpRootViewController: UIViewController {
	private lazy var buttonStackView: UIStackView = UIStackView().then {
		$0.axis = .vertical
		$0.spacing = 16
	}
	
	private lazy var startPhoneBtn: LoginButton = LoginButton(btnType: .phone)
	
	private lazy var startKakaoButton: LoginButton = LoginButton(btnType: .kakao)
	
	private lazy var startGoogleBtn: LoginButton = LoginButton(btnType: .google)
	
	private lazy var startNaverBtn: LoginButton = LoginButton(btnType: .naver)
	
	private lazy var signitureImageView: UIImageView = UIImageView(image: FallingAsset.Bx.signitureVertical.image).then {
		$0.contentMode = .scaleAspectFit
	}
	
	private let viewModel: SignUpRootViewModel
	
	private lazy var disposeBag = DisposeBag()
	
	init(viewModel: SignUpRootViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		print("[Init]: \(self)")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpView()
		bindViewModel()
	}
	
	func setUpView() {
		self.view.backgroundColor = FallingAsset.Color.netural700.color
		view.addSubview(signitureImageView)
		signitureImageView.snp.makeConstraints {
			$0.centerX.equalToSuperview()
			$0.top.equalTo(view.safeAreaLayoutGuide)
				.inset(view.bounds.height * 0.162)
			$0.height.equalTo(180)
		}
		
		self.view.addSubview(buttonStackView)
		self.buttonStackView.snp.makeConstraints {
			$0.centerX.equalToSuperview()
			$0.leading.trailing.equalToSuperview().inset(40)
			$0.bottom.equalTo(view.safeAreaLayoutGuide)
				.inset(16)
		}
		
		[startPhoneBtn, startKakaoButton, startGoogleBtn, startNaverBtn]
			.forEach {
				buttonStackView.addArrangedSubview($0)
				$0.snp.makeConstraints { make in
					make.height.equalTo(52)
				}
			}
	}
	
	func bindViewModel() {
		let input = SignUpRootViewModel.Input(
			phoneBtn: startPhoneBtn.rx.tap.asDriver(),
			kakaoBtn: startKakaoButton.rx.tap.asDriver(),
			googleBtn: startGoogleBtn.rx.tap.asDriver(),
			naverBtn: startNaverBtn.rx.tap.asDriver()
		)
		
		let output = viewModel.transform(input: input)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		print("[Deinit]: \(self)")
	}
}
