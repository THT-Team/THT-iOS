//
//  SinglePickerBottomSheet.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit

import Core

import RxSwift
import RxCocoa

public final class SinglePickerBottomSheet: TFBaseViewController {

  private let mainView = SinglePickerBottomSheetView(btnTitle: "확인")
  private let viewModel: SinglePickerBottomSheetViewModel

  public init(viewModel: SinglePickerBottomSheetViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  public override func loadView() {
    self.view = mainView
  }

  public override func viewDidLayoutSubviews() {
    self.mainView.pickerView.drawSelectedSingleLine()
    self.mainView.pickerView.drawFixcedLabel(text: "cm")
    self.navigationController?.isNavigationBarHidden = true
  }

  public override func bindViewModel() {
    let itemSelected = mainView.pickerView.rx.itemSelected.asDriver()

    let confirmTap = mainView.btn.rx.tap.asDriver()
    let input = SinglePickerBottomSheetViewModel.Input(
      selectedItem: itemSelected,
      initializeButtonTap: confirmTap
    )
    let output = viewModel.transform(input: input)

    output.items
      .drive(mainView.pickerView.rx.items(adapter: PickerViewViewAdapter()))
      .disposed(by: disposeBag)
    
    output.initialHeight
      .drive(with: self) { owner, index in
        owner.mainView.pickerView.selectRow(index, inComponent: 0, animated: true)
        owner.mainView.pickerView.delegate?.pickerView?(owner.mainView.pickerView, didSelectRow: index, inComponent: 0)
      }.disposed(by: disposeBag)
    
    output.isBtnEnabled
      .drive(mainView.btn.rx.buttonStatus)
      .disposed(by: disposeBag)
  }
}
