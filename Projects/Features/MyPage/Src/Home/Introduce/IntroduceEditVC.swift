//
//  IntroduceVC.swift
//  MyPage
//
//  Created by Kanghos on 7/22/24.
//

import UIKit
import DSKit

final class IntroduceEditVC: TFBaseViewController {
  typealias ViewModel = IntroduceEditVM
  private let viewModel: ViewModel

  init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init()
  }

  lazy var titleLabel = UILabel().then {
    $0.text = "자기소개 를 작성해주세요"
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.asColor(targetString: "자기소개", color: DSKitAsset.Color.neutral50.color)
    $0.asFont(targetString: "자기소개", font: .thtH4B)
    $0.font = .thtH4M
  }

  lazy var textField = TFResizableTextView(
    description: "자유롭게 자기소개를 작성해주세요.",
    totalCount: 200,
    placeholder: "자기소개"
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
      text: textField.rx.text
        .asDriver()
      .debug("vc textStream"),
      nextBtnTap: nextBtn.rx.tap.asSignal())

    let output = viewModel.transform(input: input)

    output.isBtnEnabled
      .drive(nextBtn.rx.buttonStatus)
      .disposed(by: disposeBag)

    output.initialText
      .drive(textField.rx.text)
      .disposed(by: disposeBag)
  }
}
