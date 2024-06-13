//
//  SinglePickerBottomSheet.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit

import Core
import DSKit

import RxSwift
import RxCocoa

final class SinglePickerBottomSheet: TFBaseViewController {

  private let mainView = SinglePickerBottomSheetView()
  private let viewModel: SinglePickerBottomSheetViewModel

  init(viewModel: SinglePickerBottomSheetViewModel) {
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
    let input = SinglePickerBottomSheetViewModel.Input(
      selectedItem: itemSelected,
      initializeButtonTap: confirmTap
    )
//
    let output = viewModel.transform(input: input)

    output.items
      .drive(mainView.pickerView.rx.items(adapter: PickerViewViewAdapter()))
      .disposed(by: disposeBag)
  }
}

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct PickerViewController_Preview: PreviewProvider {
//    static var previews: some View {
//      let vm = PickerBottomSheetViewModel(initialValue: .date(date: Date()))
//      let vc = PickerBottomSheet(viewModel: vm)
//      return vc.showPreview()
//    }
//}
//#endif
