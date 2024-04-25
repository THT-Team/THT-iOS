//
//  ReligionPickerViewController.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/25.
//

import UIKit

import DSKit

import RxSwift
import RxCocoa

final class ReligionPickerViewController: TFBaseViewController {
  typealias VMType = ReligionPickerViewModel
  private(set) var mainView = ReligionPickerView()

  private let viewModel: VMType

  init(viewModel: VMType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    self.view = mainView
  }

  override func bindViewModel() {

    let nextBtnTap = mainView.nextBtn.rx.tap.asDriver()

    let input = VMType.Input(
      chipTap: mainView.ReligionPickerView.rx.itemSelected.asDriver(),
      nextBtnTap: nextBtnTap
    )

    let output = viewModel.transform(input: input)

    output.chips
      .drive(mainView.ReligionPickerView.rx.items(cellType: ReligionPickerCell.self)) { index, item, cell in
        cell.bind(item.0)
        cell.updateCell(item.1)
      }
      .disposed(by: disposeBag)

    output.isNextBtnEnabled
      .drive(with: self) { owner, status in
        owner.mainView.nextBtn.updateColors(status: status)
      }
      .disposed(by: disposeBag)
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ReligionViewController_Preview: PreviewProvider {
  static var previews: some View {
    let vm = ReligionPickerViewModel()
    let vc = ReligionPickerViewController(viewModel: vm)
    return vc.showPreview()
  }
}
#endif
