//
//  PolicyAgreementViewController.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/10/02.
//

import UIKit

import DSKit

final class PolicyAgreementViewController: TFBaseViewController {
  private let viewModel: PolicyAgreementViewModel

  private lazy var customView = PolicyAgreementView()

  init(viewModel: PolicyAgreementViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func makeUI() {
    view.addSubview(customView)

    customView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }

  override func bindViewModel() {
    let input = PolicyAgreementViewModel.Input(
      agreeAllBtn: customView.selectAllBtn.rx.tap.asDriver(),
      tosAgreeBtn: customView.termsOfServiceRow.agreeBtn.rx.tap.asDriver(),
      showTosDetailBtn: customView.termsOfServiceRow.goWebviewBtn.rx.tap.asDriver(),
      privacyAgreeBtn: customView.privacyPolicyRow.agreeBtn.rx.tap.asDriver(),
      showPrivacyDetailBtn: customView.privacyPolicyRow.goWebviewBtn.rx.tap.asDriver(),
      locationServiceAgreeBtn: customView.locationServiceRow.agreeBtn.rx.tap.asDriver(),
      showLocationServiceDetailBtn: customView.locationServiceRow.goWebviewBtn.rx.tap.asDriver(),
      marketingServiceAgreeBtn: customView.marketingServiceRow.agreeBtn.rx.tap.asDriver(),
      nextBtn: customView.nextBtn.rx.tap.asDriver()
    )

    let output = viewModel.transform(input: input)

    output.agreeAllRowImage
      .map { $0.image }
      .drive(customView.selectAllBtn.rx.image())
      .disposed(by: disposeBag)

    output.tosAgreeRowImage
      .map { $0.image }
      .drive(customView.termsOfServiceRow.agreeBtn.rx.image())
      .disposed(by: disposeBag)

    output.privacyAgreeRowImage
      .map { $0.image }
      .drive(customView.privacyPolicyRow.agreeBtn.rx.image())
      .disposed(by: disposeBag)

    output.locationServiceAgreeRowImage
      .map { $0.image }
      .drive(customView.locationServiceRow.agreeBtn.rx.image())
      .disposed(by: disposeBag)

    output.marketingServiceRowImage
      .map { $0.image }
      .drive(customView.marketingServiceRow.agreeBtn.rx.image())
      .disposed(by: disposeBag)

    output.nextBtnStatus
      .drive(customView.nextBtn.rx.buttonStatus)
      .disposed(by: disposeBag)

    output.nextButtonTap
      .drive()
      .disposed(by: disposeBag)
  }
}
