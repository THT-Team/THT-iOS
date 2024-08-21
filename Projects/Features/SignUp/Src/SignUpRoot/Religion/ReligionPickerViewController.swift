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

final class ReligionPickerViewController: BaseSignUpVC<ReligionPickerViewModel>, StageProgressable {
  var stage: Float = 7
  private(set) var mainView = ReligionPickerView()

  override func loadView() {
    self.view = mainView
  }

  override func bindViewModel() {

    let nextBtnTap = mainView.nextBtn.rx.tap.asDriver()

    let input = ViewModel.Input(
      chipTap: mainView.ReligionPickerView.rx.itemSelected.asDriver(),
      nextBtnTap: nextBtnTap
    )

    let output = viewModel.transform(input: input)

    output.chips
      .debug("chips")
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

    mainView.ReligionPickerView.rx.observe(\.contentSize)
      .observe(on: MainScheduler.asyncInstance)
      .subscribe(with: self) { owner, size in
        owner.mainView.collectionViewHeightConstraint?.constant = size.height
        owner.mainView.layoutIfNeeded()
      }.disposed(by: disposeBag)
  }
}

