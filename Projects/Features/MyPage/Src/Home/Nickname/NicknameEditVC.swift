//
//  NicknameEditView.swift
//  MyPageInterface
//
//  Created by Kanghos on 7/22/24.
//

import UIKit
import DSKit

final class NicknameEditVC: TFBaseViewController {
  typealias ViewModel = NicknameEditVM
  private let viewModel: NicknameEditVM

  init(viewModel: NicknameEditVM) {
    self.viewModel = viewModel
    super.init()
  }

  lazy var titleLabel = UILabel().then {
    $0.text = "닉네임 을 알려주세요"
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.asColor(targetString: "닉네임", color: DSKitAsset.Color.neutral50.color)
    $0.asFont(targetString: "닉네임", font: .thtH4B)
    $0.font = .thtH4M
  }

  lazy var textField = TFCounterTextField(
    description: "폴링에서 활동할 자유로운 호칭을 설정해주세요.",
    maxLength: 12,
    placeholder: "닉네임"
  )

  lazy var nextBtn = CTAButton(btnTitle: "수정하기", initialStatus: false)

  override func makeUI() {
    self.view.backgroundColor = DSKitAsset.Color.neutral700.color
    self.view.addSubviews(titleLabel, textField, nextBtn)

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(81.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(38.adjusted)
    }
    
    textField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(64.adjustedH)
      $0.leading.trailing.equalTo(titleLabel)
    }

    nextBtn.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(38.adjusted)
      $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-24.adjustedH)
      $0.height.equalTo(54.adjustedH)
    }
  }

  override func bindViewModel() {
    addKeyboardDismissGesture()

    let input = ViewModel.Input(
      text: textField.rx.text.asDriver(),
      nextBtnTap: nextBtn.rx.tap.asSignal())

    let output = viewModel.transform(input: input)

    output.isBtnEnabled
      .drive(nextBtn.rx.buttonStatus)
      .disposed(by: disposeBag)
  }
}
