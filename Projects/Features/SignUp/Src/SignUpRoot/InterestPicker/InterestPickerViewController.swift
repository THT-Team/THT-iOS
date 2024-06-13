//
//  InterestPickerViewController.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit

import DSKit

import RxSwift
import RxCocoa

final class InterestPickerViewController: TFBaseViewController {
  typealias VMType = TagPickerViewModel
  private(set) var mainView = TagPickerView(
    titleInfo: .init(title: "관심사를 알려주세요.", targetText: "관심사"),
    subTitleInfo: .init(title: "내 관심사 3개를 선택해주세요.", targetText: "내 관심사")
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
