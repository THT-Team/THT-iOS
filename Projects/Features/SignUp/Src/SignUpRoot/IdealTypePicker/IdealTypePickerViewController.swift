//
//  IdealTypeViewController.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/24.
//

import UIKit

import DSKit

import RxSwift
import RxCocoa

final class IdealTypePickerViewController: TFBaseViewController {
  typealias VMType = IdealTypeTagPickerViewModel
  private(set) var mainView = TagPickerView(
    titleInfo: .init(title: "이상형을 알려주세요.", targetText: "이상형"),
    subTitleInfo: .init(title: "내 이상형 3개를 선택해주세요.", targetText: "내 이상형")
  )
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
      chipTap: mainView.collectionView.rx.itemSelected.asDriver(),
      nextBtnTap: nextBtnTap
    )

    let output = viewModel.transform(input: input)

    output.chips
      .drive(mainView.collectionView.rx.items(cellType: InputTagCollectionViewCell.self)) { index, viewModel, cell in
        cell.bind(viewModel)
      }
      .disposed(by: disposeBag)

    output.isNextBtnEnabled
      .drive(with: self) { owner, status in
        owner.mainView.nextBtn.updateColors(status: status)
      }
      .disposed(by: disposeBag)
  }
}
