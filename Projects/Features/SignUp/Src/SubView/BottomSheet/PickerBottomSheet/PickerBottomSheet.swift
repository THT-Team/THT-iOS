//
//  PickerButtonSheet.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/16.
//

import UIKit

import Core
import DSKit

import RxSwift
import RxCocoa

final class PickerBottomSheet: TFBaseViewController {

  private let mainView = PickerBottomSheetView()
  private let viewModel: PickerBottomSheetViewModel

  init(viewModel: PickerBottomSheetViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    self.view = mainView
  }

  override func viewDidLayoutSubviews() {
    self.mainView.drawSelectedLine()
    self.navigationController?.isNavigationBarHidden = true
  }

  override func bindViewModel() {
    let itemSelected = mainView.pickerView.rx.itemSelected.asDriver()

    let confirmTap = mainView.initializeButton.rx.tap.asDriver()
//
    let input = PickerBottomSheetViewModel.Input(
      selectedItem: itemSelected,
      initializeButtonTap: confirmTap
    )
//
    let output = viewModel.transform(input: input)

    output.items
      .drive(mainView.pickerView.rx.items(adapter: PickerViewViewAdapter()))
      .disposed(by: disposeBag)
    output.initialDate
      .drive(with: self) { owner, components in
        owner.mainView.pickerView.selectRow(components.0, inComponent: components.1, animated: false)
      }
      .disposed(by: disposeBag)
  }
}
