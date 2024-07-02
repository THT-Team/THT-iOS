//
//  HeightEditVC.swift
//  MyPage
//
//  Created by Kanghos on 7/22/24.
//

import UIKit

import DSKit

import RxSwift
import RxCocoa

final class HeightEditVC: TFBaseViewController {
  typealias ViewModel = HeightEditVM
  private let viewModel: ViewModel
  lazy var titleLabel = UILabel.setH4TargetBold(text: "키를 입력해주세요.", target: "키")
  lazy var singlePicker = UIPickerView()
  lazy var nextBtn = CTAButton(btnTitle: "수정하기", initialStatus: false)

  init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init()
  }

  override func makeUI() {
    self.navigationController?.navigationBar.isHidden = true
    self.view.backgroundColor = DSKitAsset.Color.neutral600.color
    self.view.addSubviews(titleLabel, singlePicker, nextBtn)

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(32.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(38.adjusted)
    }

    singlePicker.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.leading.trailing.equalTo(titleLabel)
    }

    nextBtn.snp.makeConstraints {
      $0.leading.trailing.equalTo(titleLabel)
      $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-24.adjustedH)
      $0.height.equalTo(54.adjustedH)
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    singlePicker.drawSelectedSingleLine()
    singlePicker.drawFixcedLabel(text: "cm")
  }

  override func bindViewModel() {
    let itemSelected = singlePicker.rx.itemSelected.asDriver()
    let btnTap = nextBtn.rx.tap.asSignal()
    let input = ViewModel.Input(
      viewDidAppear: self.rx.viewDidAppear.asDriver().mapToVoid(),
      selectedItem: itemSelected,
      btnTap: btnTap
    )
    let output = viewModel.transform(input: input)
    
    output.items.drive(singlePicker.rx.items(adapter: PickerViewViewAdapter()))
      .disposed(by: disposeBag)
    
    output.initialHeight
      .drive(with: self) { owner, index in
        owner.singlePicker.selectRow(index, inComponent: 0, animated: true)
        owner.singlePicker.delegate?.pickerView?(owner.singlePicker, didSelectRow: index, inComponent: 0)
      }.disposed(by: disposeBag)
    
    output.isBtnEnabled
      .drive(nextBtn.rx.buttonStatus)
      .disposed(by: disposeBag)
  }
}
