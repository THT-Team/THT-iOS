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

final class IdealTypePickerViewController: BaseSignUpVC<IdealTypePickerVM>, StageProgressable {
  var stage: Float = 9

  private(set) var mainView = TagPickerView(
    titleInfo: .init(title: "이상형을 알려주세요.", targetText: "이상형"),
    subTitleInfo: .init(title: "내 이상형 3개를 선택해주세요.", targetText: "내 이상형")
  )

  override func loadView() {
    self.view = mainView
  }

  override func bindViewModel() {

    let nextBtnTap = mainView.nextBtn.rx.tap.asDriver()

    let input = ViewModel.Input(
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
