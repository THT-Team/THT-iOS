//
//  UserInformationMainViewController.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 10/19/23.
//

import UIKit

import Then
import SnapKit

import RxCocoa
import RxSwift

// MARK: - Delegate
protocol UserInformationMainDelegate: AnyObject {
	func popBackToTosView()
}

// MARK: - UserInformationMainViewController
final class UserInformationMainViewController: TFBaseViewController {
	
	private let viewModel: UserInformationMainViewModel
	
	private lazy var progressBackView: UIView = UIView().then {
		$0.backgroundColor = FallingAsset.Color.disabled.color
	}
	
	private lazy var progressView: UIView = UIView().then {
		$0.backgroundColor = FallingAsset.Color.primary500.color
	}

	init(viewModel: UserInformationMainViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	override func makeUI() {
		view.addSubview(progressBackView)
		progressBackView.addSubview(progressView)
		
		progressBackView.snp.makeConstraints {
			$0.leading.trailing.equalToSuperview()
			$0.top.equalTo(view.safeAreaLayoutGuide)
			$0.height.equalTo(4)
		}
		
		progressView.snp.makeConstraints {
			$0.leading.top.bottom.equalToSuperview()
			$0.width.equalTo(0)
		}
		
		setupGetDetailUserInfoView()
	}
	
	override func bindViewModel() {
		let input = UserInformationMainViewModel.Input()
		
		let output = viewModel.transform(input: input)
		
		output.progressStep
			.debug()
			.drive(with: self, onNext: { vm, step in
				vm.setProgressBar(step: step)
			})
			.disposed(by: disposeBag)
		
		output.disposable
			.disposed(by: disposeBag)
	}
	
	private func setupGetDetailUserInfoView() {
		let nicknameInputVM = NicknameInputViewModel(
			subject: viewModel.popBackSubject,
			progressSubject: viewModel.progressSubject
		)
		
		let nicknameInputVC = NicknameInputViewController(viewModel: nicknameInputVM)
		let navigationController = UINavigationController(rootViewController: nicknameInputVC)
		
		self.addChild(navigationController)
		
		self.view.addSubview(navigationController.view)
		navigationController.view.snp.makeConstraints {
				$0.leading.trailing.equalToSuperview()
				$0.top.equalTo(progressBackView.snp.bottom)
				$0.bottom.equalTo(view.safeAreaLayoutGuide)
			}
	}
	
	private func setProgressBar(step: Double) {
		progressView.snp.updateConstraints {
			$0.width.equalTo(CGFloat(step/7) * UIScreen.main.bounds.width )
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
