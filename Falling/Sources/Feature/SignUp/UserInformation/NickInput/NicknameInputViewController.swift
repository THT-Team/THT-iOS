//
//  NicknameInputViewController.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 10/22/23.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxKeyboard

// 개발할것 정리
// 7. 다음 화면 버튼 필요


// 2. view 들어올때 키보드 처리 필요
// 3. 키보드 올라올때 화면 대응 필요
// 4. 닉네임 정책 있으면 적용 필요
// 6. 글자수 테스트 필요


final class NicknameInputViewController: TFBaseViewController {
	private let viewModel: NicknameInputViewModel
	
	private lazy var viewTitle: UILabel = UILabel().then {
		$0.text = "닉네임을 알려주세요"
		$0.textColor = FallingAsset.Color.neutral400.color
		$0.font = .thtH1B
		$0.differentTextColor(labelText: $0.text, rangeText: "닉네임", color: FallingAsset.Color.neutral50.color)
	}
	
	private lazy var topBackBtn = UIBarButtonItem().then {
		$0.image = FallingAsset.Image.chevron.image.withRenderingMode(.alwaysTemplate)
		$0.tintColor = FallingAsset.Color.neutral50.color
	}
	
	private lazy var nicknameTextField = UITextField().then {
		$0.placeholder = "닉네임"
		$0.font = .thtH3R
		$0.textColor = FallingAsset.Color.neutral50.color
	}
	
	private lazy var clearBtn: UIButton = UIButton().toClearBtn()
	
	private lazy var divider = UIView().then {
		$0.backgroundColor = FallingAsset.Color.neutral300.color
	}
	
	private lazy var countLbl = UILabel().then {
		$0.font = .thtP1B
		$0.textColor = FallingAsset.Color.neutral400.color
		$0.text = "(0/12)"
	}
	
	private lazy var nextButton = UIButton().then {
		$0.setTitle("->", for: .normal)
		$0.setTitleColor(FallingAsset.Color.neutral900.color, for: .normal)
		$0.titleLabel?.font = .thtH3B
		$0.backgroundColor = FallingAsset.Color.disabled.color
		$0.layer.cornerRadius = 11
	}
	
	private lazy var infoImageView = UIImageView().then {
		$0.image = FallingAsset.Image.explain.image.withRenderingMode(.alwaysTemplate)
		$0.tintColor = FallingAsset.Color.neutral400.color
	}
	
	private lazy var infoDesc = UILabel().then {
		$0.text = "폴링에서 활동할 자유로운 호칭을 설정해주세요."
		$0.font = .thtP2M
		$0.textColor = FallingAsset.Color.neutral400.color
	}
	
	init(viewModel: NicknameInputViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		keyboardSetting()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		nicknameTextField.becomeFirstResponder()
	}
	
	override func makeUI() {
		navigationItem.leftBarButtonItem = topBackBtn
		
		view.addSubviews([
			viewTitle, nicknameTextField, clearBtn, divider, countLbl, nextButton, infoImageView, infoDesc
		])
		
		viewTitle.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(38)
			$0.top.equalTo(view.safeAreaLayoutGuide).offset(73)
			$0.height.equalTo(40)
		}
		
		nicknameTextField.snp.makeConstraints {
			$0.leading.equalToSuperview().inset(38)
			$0.top.equalTo(viewTitle.snp.bottom).offset(64)
			$0.height.equalTo(31)
		}
		
		clearBtn.snp.makeConstraints {
			$0.leading.equalTo(nicknameTextField.snp.trailing)
			$0.trailing.equalToSuperview().inset(38)
			$0.centerY.equalTo(nicknameTextField)
			$0.width.height.equalTo(24)
		}
		
		divider.snp.makeConstraints {
			$0.leading.trailing.equalToSuperview().inset(38)
			$0.height.equalTo(2)
			$0.top.equalTo(nicknameTextField.snp.bottom).offset(6)
		}
		
		countLbl.snp.makeConstraints {
			$0.trailing.equalToSuperview().inset(38)
			$0.top.equalTo(divider.snp.bottom).offset(16)
		}
		
		nextButton.snp.makeConstraints {
			$0.trailing.equalToSuperview().inset(38)
			$0.bottom.equalToSuperview().inset(110)
			$0.width.equalTo(88)
			$0.height.equalTo(54)
		}
		
		infoImageView.snp.makeConstraints {
			$0.leading.equalTo(divider.snp.leading)
			$0.top.equalTo(divider.snp.bottom).offset(16)
			$0.width.height.equalTo(16)
		}
		
		infoDesc.snp.makeConstraints {
			$0.leading.equalTo(infoImageView.snp.trailing).offset(6)
			$0.trailing.equalTo(countLbl.snp.leading).offset(6)
			$0.centerY.equalTo(infoImageView.snp.centerY)
		}
	}
	
	override func bindViewModel() {
		let input = NicknameInputViewModel.Input(
			viewWillAppear: rx.viewWillAppear.mapToVoid().asDriverOnErrorJustEmpty(),
			topBackBtnTapped: topBackBtn.rx.tap.asDriver(),
			nicknameText: nicknameTextField.rx.text.orEmpty.asDriver(),
			clearBtnTapped: clearBtn.rx.tap.asDriver(),
			nextBtnTapped: nextButton.rx.tap.asDriver()
		)
		
		let output = viewModel.transform(input: input)
		
		output.nicknameText
			.drive(nicknameTextField.rx.text)
			.disposed(by: disposeBag)
		
		output.nicknameCntLblText
			.drive(countLbl.rx.text)
			.disposed(by: disposeBag)
		
		output.enabledStatus
			.map { $0 ? FallingAsset.Color.primary500.color : FallingAsset.Color.neutral300.color }
			.drive(divider.rx.backgroundColor)
			.disposed(by: disposeBag)
		
		output.enabledStatus
			.drive(rx.isEnableNextBtn, nextButton.rx.isEnabled)
			.disposed(by: disposeBag)
		
		output.navigateTrigger
			.drive(rx.goGenderInputView)
			.disposed(by: disposeBag)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func keyboardSetting() {
		view.rx.tapGesture()
			.when(.recognized)
			.withUnretained(self)
			.subscribe { vc, _ in
				vc.view.endEditing(true)
			}
			.disposed(by: disposeBag)
		
		RxKeyboard.instance.visibleHeight
			.skip(1)
			.drive(onNext: { [weak self] keyboardHeight in
				guard let self else { return }
				if keyboardHeight == 0 {
					self.nextButton.snp.updateConstraints {
						$0.bottom.equalToSuperview().inset(110)
					}
				} else {
					self.nextButton.snp.updateConstraints {
						$0.bottom.equalToSuperview().inset((keyboardHeight - self.view.safeAreaInsets.bottom) + 10)
					}
				}
			})
			.disposed(by: disposeBag)
	}
	
	func updateNextBtnColor(status: Bool) {
		if status {
			nextButton.backgroundColor = FallingAsset.Color.primary500.color
			nextButton.setTitleColor(FallingAsset.Color.neutral600.color, for: .normal)
		} else {
			nextButton.backgroundColor = FallingAsset.Color.disabled.color
			nextButton.setTitleColor(FallingAsset.Color.neutral900.color, for: .normal)
		}
	}
	
	func goGenderInputView() {
		let vm = GenderInputViewModel(progressSubject: viewModel.progressSubject)
		let vc = GenderInputViewController(viewModel: vm)
		navigationController?.pushViewController(vc, animated: true)
	}
}

extension Reactive where Base: NicknameInputViewController {
	var isEnableNextBtn: Binder<Bool> {
		return Binder(base.self) { vc, status in
			vc.updateNextBtnColor(status: status)
		}
	}
	
	var goGenderInputView: Binder<Void> {
		return Binder(base.self) { vc, _ in
			vc.goGenderInputView()
		}
	}
}
