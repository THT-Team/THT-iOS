//
//  PickerButtonSheet.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/16.
//

import UIKit

import Core

import RxSwift
import RxCocoa

public final class PickerBottomSheet: TFBaseViewController {

  private let mainView = PickerBottomSheetView()
  private let viewModel: PickerBottomSheetViewModel

  public init(viewModel: PickerBottomSheetViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public override func loadView() {
    self.view = mainView
  }

  public override func viewDidLayoutSubviews() {
    self.mainView.pickerView.drawSelectedLine()
    self.navigationController?.isNavigationBarHidden = true
  }

  public override func bindViewModel() {
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

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ViewController_Preview: PreviewProvider {
  static var previews: some SwiftUI.View {
    let vm = PickerBottomSheetViewModel(initialValue: .date(date: Date()))
    let vc = PickerBottomSheet(viewModel: vm)
    return vc.showPreview()
  }
}
#endif
